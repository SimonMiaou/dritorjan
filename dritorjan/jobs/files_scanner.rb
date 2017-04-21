require 'dritorjan'
require 'dritorjan/initializers/sidekiq'
require 'dritorjan/models/entry'

module Dritorjan
  module Jobs
    class FilesScanner
      include Sidekiq::Worker

      def perform
        Settings.file_manager.directories.each do |directory_path|
          entry = Models::Entry.register(directory_path)
          register_parents entry
          entry.register_content if entry.dir?
        end
      end

      private

      def register_parents(entry)
        entry = entry.register_parent while entry.path != '/'
      end
    end
  end
end
