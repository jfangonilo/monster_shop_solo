require 'rails_helper'

RSpec.describe "admin users show page" do
  before :each do
    @admin = create(:admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

    @user = create(:random_user)
  end

  it 'can be accessed from the admin users index' do
    visit "/admin/users"
    within "#user-#{@user.id}" do
      click_link("#{@user.name}")
    end
    expect(current_path).to eq("/admin/users/#{@user.id}")
  end

  it 'shows the user profile' do
    visit "/admin/users/#{@user.id}"
    within "#profile-data" do
      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.address)
      expect(page).to have_content(@user.city)
      expect(page).to have_content(@user.state)
      expect(page).to have_content(@user.zip)
    end
  end
end
