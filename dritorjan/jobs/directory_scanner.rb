require 'dritorjan'
require 'dritorjan/initializers/sidekiq'
require 'dritorjan/models/entry'

module Dritorjan
  module Jobs
    class DirectoryScanner
      include Sidekiq::Worker

      def perform(directory_path)
        entry = Models::Entry.register(directory_path)
        register_parents entry
        entry.register_content if entry.dir?
      end

      private

      def register_parents(entry)
        entry = entry.register_parent while entry.path != '/'
      end
    end
  end
end
