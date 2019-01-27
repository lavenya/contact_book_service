# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :contacts

  validates :name, :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } 

  has_secure_password
end
