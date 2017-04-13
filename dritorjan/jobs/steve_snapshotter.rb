require 'dritorjan'
require 'dritorjan/initializers/sidekiq'
require 'net/http'
require 'uri'

module Dritorjan
  module Jobs
    class SteveSnapshotter
      include Sidekiq::Worker

      def perform
        ensure_directory_exist
        ensure_subdirectory_exist
        save_current_snapshot
      rescue Errno::EHOSTUNREACH, Errno::ENETUNREACH, Net::OpenTimeout => e
        Dritorjan.logger.error(e.message)
      end

      private

      def now
        @now ||= Time.now
      end

      def subdirectory
        "#{Settings.steve_snapshotter.directory}/#{now.strftime('%Y-%m-%d')}"
      end

      def file_name
        "#{now.strftime('%H-%M-%S-%L')}.jpg"
      end

      def file_path
        "#{subdirectory}/#{file_name}"
      end

      def ensure_directory_exist
        Dir.mkdir(Settings.steve_snapshotter.directory) unless Dir.exist?(Settings.steve_snapshotter.directory)
      end

      def ensure_subdirectory_exist
        Dir.mkdir(subdirectory) unless Dir.exist?(subdirectory)
      end

      def save_current_snapshot
        file_body = Net::HTTP.get(URI.parse(Settings.steve_snapshotter.url))
        File.open(file_path, 'wb') { |file| file << file_body }
      end
    end
  end
end
