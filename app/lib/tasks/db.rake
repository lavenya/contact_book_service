# frozen_string_literal: true

# %w[db:drop db:create].each do |name|
#   Rake::Task[name].clear
# end

namespace :db do
  task drop: :load_config do
    ActiveRecord::Base.configurations.each do |_key, conf|
      begin
        MySQL.root_connection(conf).drop_database(conf['database'])
      rescue Exception => ex
        raise ex
      end
    end
  end

  task setup: :load_config do
    ActiveRecord::Base.configurations.each do |_key, conf|
      begin
        MySQL.root_connection(conf).create_database(conf['database'])
      rescue ActiveRecord::StatementInvalid => ex
        raise ex
      end
    end
    ActiveRecord::Base.establish_connection(Rails.env)
  end
end

module MySQL
  def self.root_connection(conf)
    ActiveRecord::Base.send('establish_connection', conf.merge('database' => nil))
    ActiveRecord::Base.connection
  end
end
