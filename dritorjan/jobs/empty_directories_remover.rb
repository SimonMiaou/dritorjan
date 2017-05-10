require 'dritorjan'
require 'dritorjan/initializers/sidekiq'

module Dritorjan
  module Jobs
    class EmptyDirectoriesRemover
      include Sidekiq::Worker

      def perform
        Settings.file_manager.directories.each do |directory_path|
          remove_empty_directories directory_path
        end
      end

      private

      def remove_empty_directories(directory_path)
        entries = Dir.entries(directory_path).reject { |path| path == '.' || path == '..' }

        if entries.empty? && !Settings.file_manager.directories.include?(directory_path)
          Dir.rmdir directory_path
        else
          entries.each do |entry|
            entry_path = "#{directory_path}/#{entry}"
            remove_empty_directories(entry_path) if Dir.exist?(entry_path)
          end
        end
      end
    end
  end
end
