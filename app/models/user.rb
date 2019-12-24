class User < ApplicationRecord
  has_secure_password

  validates_presence_of :name, :address, :city, :state, :zip, :email
  validates_numericality_of :zip
  validates_uniqueness_of :email, case_sensitive: false
  validates_confirmation_of :password
end