module Dritorjan
  module Helpers
    module Authentication
      def authenticate!
        redirect to('/login') unless session[:current_login].present?
      end
    end
  end
end
