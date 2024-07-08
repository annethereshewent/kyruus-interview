class Patient < ApplicationRecord
  def update_patient_info
    result = KyruusRequest.get_patient_info(self.id)

    # just do not show the user their personalized greeting if
    # for whatever reason the api is down
    if result.empty?
      return
    end

    # check both the string-based key and token-based in case one
    # of them doesn't work. this is also useful for unit tests.
    self.first_name = result["firstName"] || result[:firstName]
    self.last_name = result["lastName"] || result[:lastName]

    self.save!
  end
end
