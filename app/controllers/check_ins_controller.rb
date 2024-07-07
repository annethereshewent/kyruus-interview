class CheckInsController < ApplicationController
  def new
  end

  def create
    question_1 = params[:question_1].to_i
    question_2 = params[:question_2].to_i
    result = question_1 + question_2

    check_in = CheckIn.create(
      patient_id: "1",
      # question_1: question_1,
      # question_2: question_2,
      # result: result
    )

    redirect_to check_in_path(check_in)
  end

  def show
    @check_in = CheckIn.find(params[:id])
  end

  def update
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
  end
end
