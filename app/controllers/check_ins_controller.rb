

class CheckInsController < ApplicationController

  def new
  end

  def create
    check_in = CheckIn.create(
      patient_id: "1"
    )

    patient = Patient.find_or_create_by(id: check_in.patient_id.to_i)

    if patient.first_name.nil? && patient.last_name.nil?
      patient.update_patient_info
    end

    redirect_to check_in_path(check_in)
  end

  def show
    @check_in = CheckIn.find(params[:id])
    @patient = Patient.find(@check_in.patient_id.to_i)
  end

  def update
    unless params[:question_1].nil? || params[:question_2].nil?
      check_in = CheckIn.find(params[:id])
      check_in.update_screening_needed(params[:question_1].to_i, params[:question_2].to_i)

      redirect_to check_in_path(check_in)
    else
      redirect_to check_in_path, alert: "Please fill out all of the form."
    end
  end
end
