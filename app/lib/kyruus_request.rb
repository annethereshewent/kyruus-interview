class KyruusRequest
  def self.get_user_info id
    url = "https://dummyjson.com/users/#{id}"

    result = HTTParty.get(url)

    result.parsed_response
  end
end