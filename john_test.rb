require_relative 'john_api'
require_relative 'csv'

class JohnTest

  def initialize
    @api = JohnApi.new
  end

  COLUMNS = [
    "Machine_ID",
    "Organization_ID",
    "Engine_Hours"
  ]

  def load_and_save(filename)
    measure_time do
      File.open(filename, 'w') do |file|
        csv = Csv.new(COLUMNS)
        file.write(csv.generate_header)

        machines = list_machines
        machines.each do |machine|
          machine_id = machine['id']
          engine_hours_data = get_engine_hours(machine_id)
          file.write(csv.generate_row(machine_id, org_id, engine_hours_data))
        end
      end
    end
  end

  def list_machines
    puts @api
    @api.list_machines
  end

  def get_engine_hours(machine_id)
    @api.get_engine_hours(machine_id)
  end

  def measure_time
    started_at = Time.now
    yield
    time = Time.now - started_at
    puts "Tempo decorrido: #{time} seconds"
  end
end
