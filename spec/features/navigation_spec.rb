
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    before :each do
      visit "/"
    end

    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')
    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end
    end

    it "I can see a link to the home page" do
      within 'nav' do
        click_link "Home"
      end
      expect(current_path).to eq "/"
    end

    it "I can see a link to log in" do
      within 'nav' do
        click_link "Log In"
      end
      expect(current_path).to eq "/login"
    end
  end

  # describe 'As a registered user' do
  #   before :each do
  #     user = create(:random_user)
  #     allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(:user)
  #     visit "/"
  #   end

  #   it 'I can see a link to my profile' do
  #     within 'nav' do
  #       click_link "My Profile"
  #     end
  #     expect(current_path).to eq "/profile"
  #   end
  # end
end
