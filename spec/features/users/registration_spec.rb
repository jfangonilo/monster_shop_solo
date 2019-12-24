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
  end
end