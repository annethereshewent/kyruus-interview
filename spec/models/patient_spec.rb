require 'rails_helper'

RSpec.describe Patient, type: :model do
  describe "update_patient_info" do
    it "updates the patient info" do
      patient = create(:patient, id: 1)

      allow(KyruusRequest).to receive(:get_patient_info).with(patient.id).and_return({"firstName": "James", "lastName": "Smith"})

      patient.update_patient_info

      expect(patient.first_name).to eq("James")
      expect(patient.last_name).to eq("Smith")
    end
  end
end