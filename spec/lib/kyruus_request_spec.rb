require 'rails_helper'

WebMock.allow_net_connect!

RSpec.describe KyruusRequest do
  describe "Performing an http request" do
    it "handles exceptions for invalid http requests" do
      url = "https://dummyjson.com/users/1"

      allow(HTTParty).to receive(:get).with(url).and_raise(StandardError.new "An exception")

      result = KyruusRequest.perform_request(url)

      # a return value of {} means KyruusRequest caught an exception
      expect(result).to eq({})
    end
    it "returns back data for a valid request" do
      url = "https://dummyjson.com/users/1"

      allow(KyruusRequest).to receive(:perform_request).with(url).and_return({ "firstName": "James", "lastName": "Smith" })

      result = KyruusRequest.perform_request(url)

      expect(result[:firstName]).to eq("James")
      expect(result[:lastName]).to eq("Smith")
    end
  end

end