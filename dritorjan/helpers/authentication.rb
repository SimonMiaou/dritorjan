require 'dritorjan/models/user'

module Dritorjan
  module Helpers
    module Authentication
      def authenticate!
        session[:last_path] = request.fullpath
        redirect to('/login') unless session[:current_login].present?
      end

      def current_user
        @current_user ||= Models::User.find_by login: session[:current_login]
      end

      def current_user?
        current_user.present?
      end
    end
  end
end
