require 'dritorjan'
require 'dritorjan/initializers/sidekiq'
require 'dritorjan/models/entry'

module Dritorjan
  module Jobs
    class EntriesCleaner
      include Sidekiq::Worker

      def perform
        Models::Entry.old.destroy_all
      end
    end
  end
end
