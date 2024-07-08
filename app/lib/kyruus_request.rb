class KyruusRequest
  def self.get_patient_info id
    begin
      url = "https://dummyjson.com/users/#{id}"
      result = HTTParty.get(url)
    rescue => error
      {}
    else
      result.parsed_response
    end
  end
end