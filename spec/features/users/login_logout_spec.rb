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

  describe "As a merchant admin" do
    before :each do
      @merchant_admin = create(:merchant_admin)
    end

    it "I can log in" do
      visit "/login"

      fill_in "Email", with: @merchant_admin.email
      fill_in "Password", with: @merchant_admin.password

      click_button "Log In"
      expect(current_path).to eq "/merchant"
      expect(page).to have_content "You are logged in"
    end
  end

  describe "As an admin" do
    before :each do
      @admin = create(:admin)
    end

    it "I can log in" do
      visit "/login"

      fill_in "Email", with: @admin.email
      fill_in "Password", with: @admin.password

      click_button "Log In"
      expect(current_path).to eq "/admin"
      expect(page).to have_content "You are logged in"
    end
  end

  describe "I can't log in w/ bad credentials" do
    before :each do
      @user = create(:random_user)
    end

    it "bad email" do
      visit "/login"
      fill_in "Email", with: "wrong_email@mail.com"
      fill_in "Password", with: @user.password

      click_button "Log In"
      expect(page).to have_content "Invalid email or password"
      expect(page). to have_button "Log In"
    end

    it "bad password" do
      visit "/login"
      fill_in "Email", with: @user.email
      fill_in "Password", with: "wrong_password"

      click_button "Log In"
      expect(page).to have_content "Invalid email or password"
      expect(page). to have_button "Log In"
    end
  end
end