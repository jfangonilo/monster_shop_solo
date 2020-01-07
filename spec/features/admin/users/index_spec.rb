require 'rails_helper'

RSpec.describe "admin users index page" do
  before :each do
    @user_1 = create(:random_user)
    @user_2 = create(:merchant_employee)
    @user_3 = create(:merchant_admin)
    @admin = create(:admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  end

  it 'can be accessed from the nav bar' do
    visit "/"
    within ".topnav" do
      click_link("All Users")
    end
    expect(current_path).to eq("/admin/users")
  end

  it 'displays all users' do
    visit "/admin/users"

    within "#user-#{@user_1.id}" do
      expect(page).to have_link("#{@user_1.name}")
      expect(page).to have_content("#{@user_1.created_at}")
      expect(page).to have_content("#{@user_1.role}")
    end

    within "#user-#{@user_2.id}" do
      expect(page).to have_link("#{@user_2.name}")
      expect(page).to have_content("#{@user_2.created_at}")
      expect(page).to have_content("#{@user_2.role}")
    end

    within "#user-#{@user_3.id}" do
      expect(page).to have_link("#{@user_3.name}")
      expect(page).to have_content("#{@user_3.created_at}")
      expect(page).to have_content("#{@user_3.role}")
    end

    within "#user-#{@admin.id}" do
      expect(page).to have_link("#{@admin.name}")
      expect(page).to have_content("#{@admin.created_at}")
      expect(page).to have_content("#{@admin.role}")
    end
  end

  it 'can activate and deactivate users' do
    visit "/admin/users"

    within "#user-#{@user_2.id}" do
      expect(page).to have_button "Deactivate User"
    end

    within "#user-#{@user_3.id}" do
      expect(page).to have_button "Deactivate User"
    end

    within "#user-#{@admin.id}" do
      expect(page).not_to have_button "Deactivate User"
    end

    within "#user-#{@user_1.id}" do
      click_button "Deactivate User"
    end

    expect(current_path).to eq "/admin/users"
    @user_1.reload
    expect(@user_1.active?).to be false

    within "#user-#{@user_1.id}" do
      click_button "Activate User"
    end

    expect(current_path).to eq "/admin/users"
    @user_1.reload
    expect(@user_1.active?).to be true
  end

end
