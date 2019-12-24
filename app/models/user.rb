class User < ApplicationRecord
  has_secure_password

  validates_presence_of :name, :address, :city, :state, :zip, :email
  validates_numericality_of :zip
  validates_uniqueness_of :email
  validates_confirmation_pf :password
end