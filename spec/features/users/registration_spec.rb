require 'rails_helper'

RSpec.describe 'User Registration' do
  describe 'As a visitor' do
    it 'I can see a link to register' do
      visit '/'
      within 'nav' do
        click_link "Register" do
      end
      expect(current_path).to eq '/register'
      end
    end

    it 'I can register as a user' do
      visit '/'
      within 'nav' do
        click_link 'Register'
      end

      fill_in :user_name, with: 'Fake Name'
      fill_in :user_address, with: 'Fake Address'
      fill_in :user_city, with: 'Fake City'
      fill_in :user_state, with: 'Fake State'
      fill_in :user_zip, with: '98765'
      fill_in :user_email, with: 'fake@name.com'
      fill_in :user_password, with: '12345'
      fill_in :user_password_confirmation, with: '12345'
      click_button 'Submit'

      expect(current_path).to eq '/profile'
      expect(page).to have_content 'You are now registered and logged in, Fake Name'
    end
  end
end