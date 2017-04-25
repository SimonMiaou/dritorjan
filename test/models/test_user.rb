require 'test_helper'
require 'dritorjan/models/user'
require 'factories/user'

module Dritorjan
  module Models
    class TestUser < Minitest::Test
      def test_password_match?
        user = build(:user, password: '$5$s6IjXqlRbpf/3yL/$UNGeSd3s3prGB9hyQrOEJC3pny4KTyBb6DsDKItbp21')
        assert user.password_match?('Hello world!')
        refute user.password_match?('hello world!')
        refute user.password_match?('Hello world')

        user = build(:user, password: '$6$I9sPiHxKQgXyRiUr$hJa0Ok1nS.ktEnDDVU6DYJ75zkr2MtmvziEsb7J1vVsC/mwG1MlsH2T/2YC2dlHD3lyqqQeRs.Llq//5nlv43.')
        assert user.password_match?('BOOMBAYAH')
        refute user.password_match?('BAYAHBOOM')
      end
    end
  end
end
