require 'dritorjan/database'
require 'etc'
require 'unix_crypt'

Dritorjan::Database.connect

module Dritorjan
  module Models
    class User < ActiveRecord::Base
      self.table_name = :users
      self.primary_key = :login

      validates :login, :full_name, :password, presence: true

      def self.import_from_shadow_file
        shadow = `sudo cat /etc/shadow`
        shadow.split("\n").each do |line|
          data = line.split ':'
          next unless data[1] != '*'

          user = find_or_initialize_by login: data[0]
          user.full_name = Etc.getpwnam(data[0]).gecos
          user.password = data[1]
          user.save!
        end
      end

      def password_match?(value)
        UnixCrypt.valid? value, password
      end
    end
  end
end
