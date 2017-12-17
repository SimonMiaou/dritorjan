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
        scan_for_empty_sub_directories(directory_path)
        remove_if_empty(directory_path)
      end

      def scan_for_empty_sub_directories(directory_path)
        entries_for(directory_path).each do |entry|
          entry_path = "#{directory_path}/#{entry}"
          remove_empty_directories(entry_path) if Dir.exist?(entry_path)
        end
      end

      def remove_if_empty(directory_path)
        Dir.rmdir directory_path if entries_for(directory_path).empty? && !Settings.file_manager.directories.include?(directory_path)
      end

      def entries_for(directory_path)
        return [] unless Dir.exist?(directory_path)
        Dir.entries(directory_path).reject { |path| path == '.' || path == '..' }
      end
    end
  end
end
