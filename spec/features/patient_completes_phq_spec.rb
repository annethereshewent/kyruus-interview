require "rails_helper"

RSpec.feature "A patient checks into the app" do
  scenario "for a scheduled appointment" do
    visit root_path

    click_on "Start check in"

    expect(page).to have_content "Please complete all of the steps on this page"

    click_on "Start PHQ screener"

    expect(page).to have_content("Over the past 2 weeks, how often have you been bothered by any of the following problems?")

    expect(page).to have_content("1. Little interest or pleasure in doing things?")

    expect(page).to have_content("2. Feeling down, depressed or hopeless?")
  end
end
