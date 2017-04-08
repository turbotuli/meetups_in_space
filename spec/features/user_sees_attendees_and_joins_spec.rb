require 'spec_helper'

feature "User can view attendees, join and leave meetups" do
  let!(:jarlax1) do
    User.create(
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end
  let!(:turbotuli) do
    User.create(
      provider: "github",
      uid: "2",
      username: "turbotuli",
      email: "turbotuli@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/23174767?v=3&u=895da66eb7436585b86bc6335a462a17665507bd&s=400"
    )
  end
  let!(:snarlax) do
    User.create(
      provider: "github",
      uid: "3",
      username: "snarlax",
      email: "snarlax@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174827?v=3&s=400"
    )
  end

  let!(:meetup) do
    Meetup.create(
      creator_id: jarlax1.id,
      name: "Meetup in Pry",
      description: "Check table validations",
      location: "Pry",
      date: "1/5/2017"
    )
  end
  let!(:attendee_one) { Attendee.create(meetup_id: meetup.id, user_id: jarlax1.id) }
  let!(:attendee_two) { Attendee.create(meetup_id: meetup.id, user_id: turbotuli.id) }

  scenario "user sees attendees of a meetup" do
    visit '/meetups'
    click_link("Meetup in Pry")
    expect(page).to have_content("jarlax1")
    expect(page).to have_content("turbotuli")
    expect(page).not_to have_content("snarlax")
    expect(page.find("#icon-#{jarlax1.id}")['src']).to eq("https://avatars2.githubusercontent.com/u/174825?v=3&s=400")
    expect(page.find("#icon-#{turbotuli.id}")['src']).to eq("https://avatars2.githubusercontent.com/u/23174767?v=3&u=895da66eb7436585b86bc6335a462a17665507bd&s=400")
  end

  scenario "Unauthenticated user is asked to sign in if they try to join the meetup" do
    visit "/meetups/#{meetup.id}"
    click_button 'Join'
    expect(page).to have_content("Please sign in!")
    expect(page).to have_content("Meetup in Pry")
  end

  scenario "Authenticated user can join the meetup" do
    sign_in_as snarlax
    visit "/meetups/#{meetup.id}"
    expect(page).to have_content("Meetup in Pry")
    within("#attendees") do
      expect(page).not_to have_content("snarlax")
    end
    click_button 'Join'
    expect(page).to have_content("You have joined the meetup!")
    within("#attendees") do
      expect(page).to have_content("snarlax")
    end
  end

  scenario "Authenticated user can leave a meetup they have joined" do
    sign_in_as jarlax1
    visit "/meetups/#{meetup.id}"
    within("#attendees") do
      expect(page).to have_content("jarlax1")
    end
    click_button('Leave')
    expect(page).to have_content("You have left the meetup.")
    within("#attendees") do
      expect(page).not_to have_content("jarlax1")
    end
  end

end
