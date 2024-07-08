require 'rails_helper'

RSpec.describe CheckIn, type: :model do
  it { should validate_presence_of :patient_id }

  describe "update_screening_needed" do
    it "recommends screening needed if either question has value greater than 1" do
      check_in = create(:check_in, id: 1, patient_id: "1")

      check_in.update_screening_needed(1, 3)

      expect(check_in.screening_needed).to eq(true)
    end

    it "does not recommend screening needed if either question is less than 2" do
      check_in = create(:check_in, id: 1, patient_id: "1")

      check_in.update_screening_needed(1, 0)

      expect(check_in.screening_needed).to eq(false)
    end
  end
end
