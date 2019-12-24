class User < ApplicationRecord
  has_secure_password

  validates_presence_of :name, :address, :city, :state, :zip, :email
end