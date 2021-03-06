require 'rails_helper'

RSpec.describe User do
  describe 'Validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should validate_numericality_of :zip }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email}
    it { should validate_confirmation_of :password}
  end

  describe "relationships" do
    it { should have_many :orders }
    it { should belong_to(:merchant).optional }
  end
end