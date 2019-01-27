# frozen_string_literal: true

class Contact < ActiveRecord::Base
  include Searchable

  belongs_to :user

  validates :name, :email, presence: true
  validates :email, uniqueness: { scope: :user_id, message: 'already exists' }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } 

  self.per_page = 10

  def es_payload
    as_json(
      root: false,
      only: [:id, :name, :email, :user_id]
    )
  end

  def self.search_query(query, user_id)
    { query: {
        bool: {
          must: {
            multi_match: {
              query: query,
              type: 'phrase',
              fields: ['name', 'email']
            }
          },
          filter: {
            term: {
              user_id: user_id
            }
          }
        }
      }
    }
  end
end
