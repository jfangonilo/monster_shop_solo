require "rails_helper"

RSpec.describe "user profile page" do
  it "shows all my profile data except password" do
    user = create(:random_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit "/profile"

    within "#profile-data" do
      expect(page).to have_content user.name
      expect(page).to have_content user.email
      expect(page).to have_content user.address
      expect(page).to have_content user.city
      expect(page).to have_content user.state
      expect(page).to have_content user.zip
      expect(page).not_to have_content user.password
    end
  end

  it "has a link to edit my data" do
    user = create(:random_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit "/profile"
    expect(page).to have_link "Edit Profile"
  end
end