class Csv

  def initialize(columns)
    @columns = columns
  end

  def self.from(data)
    return if data.empty?
    c = Csv.new(data.first.keys)
    return c.generate_header + c.generate_rows(data)
  end

  def generate_header
    csv = ''
    @columns.each do |h|
      csv += quote(h)
      csv += "\t"
    end
    csv += "\n"
    return csv
  end

  def generate_rows(data)
    csv = ''
    data.each do |row|
      @columns.each do |h|
        csv += quote(row[h])
        csv += "\t"
      end
      csv += "\n"
    end
    return csv
  end

  private

  def quote(value)
    "\"#{value}\""
  end

  def test_machinestate(hours_ago = 0, interval = 6)
    now = Time.now - hours_ago * 60 * 60
    ago = now - interval * 60 * 60
    @api.machinestate(4694, ago, now)
  end

  def load_and_save(filename)
    measure_time do
      File.open(filename, 'w') do |file|
        csv = Csv.new(COLUMNS)
        file.write(csv.generate_header)
        (0..30).each do |n|
          ms = test_machinestate(n * 24, 24)
          file.write(csv.generate_rows(ms))
        end
      end
    end
  end

  def async_load_and_save(filename)
    measure_time do
      parts = Queue.new
      threads = []
      csv = Csv.new(COLUMNS)
      (0..30).each do |n|
        threads << Thread.new do
          ms = test_machinestate(n * 24, 24)
          parts << csv.generate_rows(ms)
        end
      end
      File.open(filename, 'w') do |file|
        file.write(csv.generate_header)
        threads.size.times do
          part = parts.pop
          file.write(part)
        end
      end
      threads.each &:join
    end
  end

  def measure_time
    started_at = Time.now
    r = yield
    time = Time.now - started_at
    puts "Tempo decorrido: #{time} seconds"
    return r
  end


end
