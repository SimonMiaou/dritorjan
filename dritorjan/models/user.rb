require 'dritorjan/database'
require 'unix_crypt'

Dritorjan::Database.connect

module Dritorjan
  module Models
    class User < ActiveRecord::Base
      self.table_name = :users
      self.primary_key = :login

      validates :login, :full_name, :password, presence: true

      def password_match?(value)
        UnixCrypt.valid? value, password
      end
    end
  end
end
