require "rails_helper"

WebMock.allow_net_connect!

RSpec.feature "A patient checks into the app" do
  scenario "for a scheduled appointment" do
    visit root_path

    click_on "Start check in"

    expect(page).to have_content "Please complete all of the steps on this page"

    click_on "Start PHQ screener"

    expect(page).to have_content("Over the past 2 weeks, how often have you been bothered by any of the following problems?")

    expect(page).to have_content("1. Little interest or pleasure in doing things?")

    expect(page).to have_content("2. Feeling down, depressed or hopeless?")

    expect(page).to have_content("Welcome Emily Johnson")
  end

  scenario "for a patient that needs no further screening" do
    visit root_path

    click_on "Start check in"
    click_on "Start PHQ screener"

    choose("question_1", option: "0")
    choose("question_2", option: "1")

    click_on "Complete check in"

    expect(page).to have_content("Questionnaire complete. According to the results, no further screening is required.")
  end

  scenario "for a patient that needs further screening" do
    visit root_path

    click_on "Start check in"
    click_on "Start PHQ screener"

    choose("question_1", option: "2")
    choose("question_2", option: "1")

    click_on "Complete check in"

    expect(page).to have_content("Questionnaire complete. According to the results, additional screening should be completed.")
  end
end
