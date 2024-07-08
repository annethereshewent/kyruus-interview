require "rails_helper"

RSpec.feature "A patient checks into the app" do
  scenario "for a scheduled appointment" do
    visit root_path

    allow(KyruusRequest).to receive(:get_patient_info).with(1).and_return({"firstName": "James", "lastName": "Smith"})

    click_on "Start check in"

    expect(page).to have_content("Welcome James Smith")

    expect(page).to have_content "Please complete all of the steps on this page"

    click_on "Start PHQ screener"

    expect(page).to have_content("Over the past 2 weeks, how often have you been bothered by any of the following problems?")

    expect(page).to have_content("1. Little interest or pleasure in doing things?")

    expect(page).to have_content("2. Feeling down, depressed or hopeless?")

    expect(page).to have_content("Not at all")
    expect(page).to have_content("Several days")
    expect(page).to have_content("More than half the days")
    expect(page).to have_content("Nearly every day")
  end

  scenario "for a patient that needs no further screening" do
    visit root_path

    allow(KyruusRequest).to receive(:get_patient_info).with(1).and_return({"firstName": "James", "lastName": "Smith"})

    click_on "Start check in"
    click_on "Start PHQ screener"

    choose("question_1", option: "0")
    choose("question_2", option: "1")

    click_on "Complete check in"

    expect(page).to have_content("Questionnaire complete. According to the results, no further screening is required.")
  end

  scenario "for a patient that needs further screening" do
    visit root_path

    allow(KyruusRequest).to receive(:get_patient_info).with(1).and_return({"firstName": "James", "lastName": "Smith"})

    click_on "Start check in"
    click_on "Start PHQ screener"

    choose("question_1", option: "2")
    choose("question_2", option: "1")

    click_on "Complete check in"

    expect(page).to have_content("Questionnaire complete. According to the results, additional screening should be completed.")
  end

  scenario "for a patient that does not fill out the form" do
    visit root_path

    allow(KyruusRequest).to receive(:get_patient_info).with(1).and_return({"firstName": "James", "lastName": "Smith"})

    click_on "Start check in"
    click_on "Start PHQ screener"

    click_on "Complete check in"

    expect(page).to have_content("Please fill out all of the form.")
  end
end
