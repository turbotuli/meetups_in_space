require 'spec_helper'

feature "Unauthenticated User views the index and meetup details pages" do
  before(:each) do
    user = User.create(
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
    Meetup.create(
      creator_id: user.id,
      name: "Meetup in Pry",
      description: "Check table validations",
      location: "Pry",
      date: "1/5/2017"
    )
    Meetup.create(
      creator_id: user.id,
      name: "Before and After Hooks",
      description: "'let!' will create a new instance each time it's called.",
      location: "rSpec",
      date: "May 4th, 2017"
    )
  end
  scenario "user sees a list of all meetups with dates" do
    visit '/meetups'
    expect(page).to have_content("Meetup in Pry")
    expect(page).to have_content("05/01/17")
    expect(page).to have_content("Before and After Hooks")
    expect(page).to have_content("05/04/17")
  end

  scenario "user clicks on a meetup to see it's details" do
    visit '/meetups'
    expect(page).to have_link("Meetup in Pry")
    click_link("Meetup in Pry")
    expect(page).to have_content("Meetup in Pry")
    expect(page).to have_content("Location: Pry")
    expect(page).to have_content("Description: Check table validations")
    expect(page).to have_content("Created by: jarlax1")
  end

end
