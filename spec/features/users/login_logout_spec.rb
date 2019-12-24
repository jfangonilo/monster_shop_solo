require "rails_helper"

RSpec.describe "User Login and Logout" do
  describe "As a regular user" do
    before :each do
      @user = create(:random_user)
    end

    it "I can log in" do
      visit "/login"

      fill_in "Email", with: @user.email
      fill_in "Password", with: @user.password

      click_button "Log In"
      expect(current_path).to eq "/profile"
      expect(page).to have_content "You are logged in"
    end
  end

  describe "As a merchant employee" do
    before :each do
      @merchant_employee = create(:merchant_employee)
    end

    it "I can log in" do
      visit "/login"

      fill_in "Email", with: @merchant_employee.email
      fill_in "Password", with: @merchant_employee.password

      click_button "Log In"
      expect(current_path).to eq "/merchant"
      expect(page).to have_content "You are logged in"
    end
  end
end