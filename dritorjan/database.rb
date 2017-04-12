require 'dritorjan'
require 'active_record'

module Dritorjan
  module Database
    def self.connect
      configurations = YAML.safe_load(File.read('./config/database.yml'))
      ActiveRecord::Base.establish_connection(configurations[Dritorjan.env])
    end

    def self.create_tables
      ActiveRecord::Schema.define do
        create_table :entries do |t|
          t.string :path, null: false
          t.string :dirname, null: false
          t.string :basename, null: false
          t.datetime :mtime, null: false
          t.bigint :size, null: false
          t.datetime :updated_at, null: false
        end
        add_index :entries, :path
      end
    end

    def self.drop_tables
      ActiveRecord::Schema.define do
        drop_table :entries if table_exists? :entries
      end
    end
  end
end
