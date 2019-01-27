# frozen_string_literal: true

require 'elasticsearch/model'

module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    def self.search(query, user_id)
      __elasticsearch__.search(search_query(query, user_id), _source: 'false')
    end

    def self.es_search_with_pagination(query, user_id, page)
      results = search(query, user_id)
      contact_ids = results.map(&:id)
      self.where(id: contact_ids).paginate(page: page)
    end

    def as_indexed_json(options = {})
      es_payload
    end
  end
end
