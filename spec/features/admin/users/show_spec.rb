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
end
