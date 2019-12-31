require 'rails_helper'

RSpec.describe "admin users index page" do
  before :each do
    @user_1 = create(:random_user)
    @user_1 = create(:random_user, email: "fake2@mail.com")
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
end
