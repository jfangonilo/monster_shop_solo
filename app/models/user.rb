class User < ApplicationRecord
  has_secure_password
  validates :email, uniqueness: true, case_sensitive: false

  validates_presence_of :name, :address, :city, :state, :zip, :email
  validates_numericality_of :zip
  validates_confirmation_of :password

  enum role: %w(user merchant_employee merchant_admin admin)
end