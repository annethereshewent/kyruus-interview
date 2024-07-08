class KyruusRequest
  def self.perform_request url
    begin
      result = HTTParty.get(url)
    rescue => error
      {}
    else
      result.parsed_response
    end
  end
end