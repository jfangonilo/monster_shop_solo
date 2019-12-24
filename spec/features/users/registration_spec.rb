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

    it "I see a flash message if I miss any fields" do
      visit '/'
      within 'nav' do
        click_link 'Register'
      end
      click_button 'Submit'

      expect(page).to have_button "Submit"
      expect(page).to have_content "Name can't be blank"
      expect(page).to have_content "Address can't be blank"
      expect(page).to have_content "City can't be blank"
      expect(page).to have_content "State can't be blank"
      expect(page).to have_content "Zip can't be blank"
      expect(page).to have_content "Email can't be blank"
      expect(page).to have_content "Password can't be blank"
      expect(page).to have_content "Password confirmation doesn't match Password"
    end

    it "I must use a unique email" do
      user = create(:random_user)

      visit '/'
      within 'nav' do
        click_link 'Register'
      end

      fill_in :user_name, with: user.name
      fill_in :user_address, with: user.address
      fill_in :user_city, with: user.city
      fill_in :user_state, with: user.state
      fill_in :user_zip, with: user.zip
      fill_in :user_email, with: user.email
      fill_in :user_password, with: user.password
      fill_in :user_password_confirmation, with: user.password
      click_button 'Submit'

      expect(page).to have_content "Email has already been taken"
    end
  end
end