# frozen_string_literal: true

namespace :db do
  desc 'Setup database'
  task bootstrap: :environment do
    ENV['RAILS_ENV'] = Rails.env

    if Rails.env.development? || Rails.env.test?
      Rake::Task['db:drop'].invoke
      Rake::Task['db:setup'].invoke
    end
  end
end
