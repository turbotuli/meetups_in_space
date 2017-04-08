require 'spec_helper'

feature "User creates new meetup" do
  let(:user) do
    User.create(
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
      )
  end

  scenario "Unauthenticated user is told to sign in" do
    visit '/meetups'
    click_link("New Meetup")
    within(".flash") do
      expect(page).to have_content("Please sign in!")
    end
  end

  scenario "Authenticated user creates a new meetup" do
    visit '/meetups'
    sign_in_as user
    click_link("New Meetup")
    expect(page).to have_content("New Meetup")
    fill_in "Name", with: "TDD with Capybara"
    fill_in "Location", with: "Command Line"
    fill_in "Description", with: "How and why we write unit tests to drive our software."
    fill_in "Date", with: "13/4/2017"
    click_button "Create"
    expect(page).to have_content("TDD with Capybara")
    within(".flash") do
      expect(page).to have_content("Meetup created!")
    end
  end

  scenario "Authenticated user tries to create an invalid meetup" do
    visit '/meetups'
    sign_in_as user
    click_link("New Meetup")
    fill_in "Description", with: "Testing pre-filling"
    click_button "Create"
    description = find_by_id("description")
    expect(description.value).to eq("Testing pre-filling")
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content("Location can't be blank")
    expect(page).to have_content("Date can't be blank")
  end



end
