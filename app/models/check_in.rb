class CheckIn < ApplicationRecord
  validates :patient_id, presence: true

  def update_screening_needed(question_1, question_2)
    screening_needed = question_1 > 1 || question_2 > 1

    self.update(
      question_1: question_1,
      question_2: question_2,
      screening_needed: screening_needed
    )
  end
end
