require 'dritorjan'
require 'dritorjan/initializers/sidekiq'
require 'dritorjan/jobs/directory_scanner'
require 'dritorjan/models/entry'

module Dritorjan
  module Jobs
    class ScanRunner
      include Sidekiq::Worker

      def perform
        Settings.file_manager.directories.each do |directory_path|
          DirectoryScanner.perform_async directory_path
        end
      end
    end
  end
end
