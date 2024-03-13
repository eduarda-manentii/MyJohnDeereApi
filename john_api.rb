require 'faraday'
require 'base64'
require 'json'

class JohnApi
  TOKEN_URL = 'https://signin.johndeere.com/oauth2/aus78tnlaysMraFhC1t7/v1/token'
  API_URL = 'https://sandboxapi.deere.com/platform'

  def initialize
    @client_id = "your_client_id"
    @client_secret = "your_client_secret"
    @access_token = nil
    @scopes = '?'
  end

  def authenticate(scopes = @scopes)
    auth_header = Base64.strict_encode64("#{@client_id}:#{@client_secret}")
    conn = Faraday.new(url: TOKEN_URL) do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end

    response = conn.post do |req|
      req.headers['Authorization'] = "Basic #{auth_header}"
      req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
      req.body = URI.encode_www_form(
        grant_type: 'client_credentials',
        scope: scopes
      )
    end
    token_data = JSON.parse(response.body)
    @access_token = token_data['access_token']
  end

  def make_request(endpoint, method = :get, payload = nil)
    authenticate if @access_token.nil?

    conn = Faraday.new(url: API_URL) do |faraday|
      faraday.request :json
      faraday.response :json, content_type: /\bjson$/
      faraday.adapter Faraday.default_adapter
      faraday.headers['Authorization'] = "Bearer #{@access_token}"
    end

    case method
    when :get
      response = conn.get(endpoint)
    when :post
      response = conn.post(endpoint, payload)
    when :put
      response = conn.put(endpoint, payload)
    when :delete
      response = conn.delete(endpoint)
    else
      raise ArgumentError, 'Invalid HTTP method provided'
    end
    response.body
  end

  def list_organizations
    #TODO
  end

  def get_engine_hours
    #TODO
  end

end
