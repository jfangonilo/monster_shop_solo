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

  it "lets me edit my profile" do
    user = create(:random_user, name: "OG Fake Name")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit "/profile/edit"

    fill_in "Name", with: "fake name"
    fill_in "Address", with: "fake address"
    fill_in "City", with: "fake city"
    fill_in "State", with: "fake state"
    fill_in "Zip", with: "90210"
    fill_in "Email", with: "fake2@email.com"
    click_button "Update Profile"

    expect(current_path).to eq "/profile"
    expect(page).to have_content "fake name"
    expect(page).to have_content "fake address"
    expect(page).to have_content "fake city"
    expect(page).to have_content "fake state"
    expect(page).to have_content "90210"
    expect(page).to have_content "fake2@email.com"
    expect(page).to have_content "Profile Updated!"

    expect(page).not_to have_content "OG Fake Name"
  end

  it "lets me change my password" do
    user = create(:random_user, name: "OG Fake Name")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit "/profile"
    click_link "Change Password"

    expect(current_path).to eq "/profile/edit_password"
    fill_in "Password", with: "verysecure"
    fill_in "Password confirmation", with: "verysecure"
    click_button "Change Password"
    expect(current_path).to eq "/profile"
    expect(page).to have_content "Password Updated!"
  end

  it "doesn't let me change pw if fields don't match" do
    user = create(:random_user, name: "OG Fake Name")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit "/profile/edit_password"
    fill_in "Password", with: "verysecure"
    fill_in "Password confirmation", with: "notverysecure"
    click_button "Change Password"

    expect(current_path).to eq "/profile/edit_password"
    expect(page).to have_content "Passwords don't match!"
  end
end