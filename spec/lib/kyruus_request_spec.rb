require 'rails_helper'

RSpec.describe KyruusRequest do
  describe "Performing an http request" do

    it "handles exceptions and returns back an empty hash" do
      url = "https://dummyjson.com/users/1"

      allow(HTTParty).to receive(:get).with(url).and_raise(StandardError.new "An exception")

      result = KyruusRequest.get_patient_info("1")

      # a return value of {} means KyruusRequest caught an exception
      expect(result).to eq({})
    end
    it "returns back data for a valid request" do
      url = "https://dummyjson.com/users/1"

      stub_request(:get, url)
        .to_return(body: "{\"firstName\": \"James\", \"lastName\": \"Smith\"}", headers: { content_type: "application/json" })

      result = KyruusRequest.get_patient_info("1")

      expect(result["firstName"]).to eq("James")
      expect(result["lastName"]).to eq("Smith")
    end
  end
end