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
          entry.register_content if entry.dir?
        end
      end
    end
  end
end
