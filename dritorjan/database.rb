require 'dritorjan'
require 'active_record'

module Dritorjan
  module Database
    def self.connect
      ActiveRecord::Base.establish_connection(configuration)
    end

    def self.create_database
      ActiveRecord::Base.establish_connection(configuration.merge(database: 'postgres'))
      ActiveRecord::Base.connection.create_database(configuration[:database], configuration)
    end

    def self.create_tables
      ActiveRecord::Schema.define do
        create_table :entries, id: false, primary_key: :path do |t|
          t.string :path, null: false
          t.string :dirname, null: false
          t.string :basename, null: false
          t.datetime :mtime, null: false
          t.bigint :size, null: false
        end
        add_index :entries, :path
      end
    end

    def self.drop_tables
      ActiveRecord::Schema.define do
        drop_table :entries if table_exists? :entries
      end
    end

    def self.configuration
      YAML.safe_load(File.read('./config/database.yml'))[Dritorjan.env].symbolize_keys
    end
  end
end
