# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :contacts

  validates :name, :email, presence: true
  validates :email, uniqueness: true
end
