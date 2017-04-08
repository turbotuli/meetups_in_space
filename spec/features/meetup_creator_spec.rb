require 'spec_helper'

feature "Meetup creators can edit and delete their meetups" do
  before(:each) do
    user = User.create(
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
    meetup = Meetup.create(
      creator_id: user.id,
      name: "Meetup in Pry",
      description: "Check table validations",
      location: "Pry",
      date: "1/5/2017"
    )
  end

  let(:meetup) { Meetup.all.first }
  let(:snarlax) { User.all.first }

  scenario "meetup creator edits their meetup" do
    sign_in_as snarlax
    visit "/meetups/#{meetup.id}"
    click_button('Edit')
    fill_in 'Name', with: "This meetup is changing"
    click_button('Submit')
    expect(page).to have_content("Meetup updated!")
    expect(page).to have_content("This meetup is changing")
  end

  scenario "meetup creator edits their meetup with invalid details" do
    sign_in_as snarlax
    visit "/meetups/#{meetup.id}"
    click_button('Edit')
    expect(page).to have_current_path("/meetups/edit/#{meetup.id}")
    fill_in 'Name', with: ""
    click_button('Submit')
    expect(page).to have_content("Name can't be blank")
  end

  scenario "meetup creator deletes their meetup" do
    sign_in_as snarlax
    visit "/meetups/#{meetup.id}"
    click_button('Delete')
    expect(page).to have_current_path('/meetups')
    expect(page).to have_content("Meetup deleted.")
    expect(page).not_to have_content("Meetup in Pry")
  end

end
