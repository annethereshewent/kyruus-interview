

class CheckInsController < ApplicationController

  def new
  end

  def create
    check_in = CheckIn.create(
      patient_id: "1"
    )

    patient = Patient.find_or_create_by(id: check_in.patient_id.to_i)

    if patient.first_name.nil? && patient.last_name.nil?
      result = KyruusRequest.get_user_info(check_in.patient_id)

      # the ||'s are needed to pass unit tests. look at the unit tests
      # to see why, but basically the mock is returning back hashes
      # with token-based keys instead of string-based.
      patient.first_name = result["firstName"] || result[:firstName]
      patient.last_name = result["lastName"] || result[:lastName]

      patient.save!
    end

    redirect_to check_in_path(check_in)
  end

  def show
    @check_in = CheckIn.find(params[:id])
    @patient = Patient.find(@check_in.patient_id.to_i)
  end

  def update
    unless params[:question_1].nil? || params[:question_2].nil?
      question_1 = params[:question_1].to_i
      question_2 = params[:question_2].to_i

      screening_needed = question_1 > 1 || question_2 > 1

      @check_in = CheckIn.find(params[:id])

      @check_in.update(
        question_1: question_1,
        question_2: question_2,
        screening_needed: screening_needed
      )
      redirect_to check_in_path
    else
      redirect_to check_in_path, alert: "Please fill out the required fields."
    end
  end
end
