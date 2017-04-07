require 'dritorjan/initializers/sidekiq'
require 'net/http'
require 'uri'

module Dritorjan
  class SteveSnapshotter
    include Sidekiq::Worker

    def perform
      ensure_directory_exist
      ensure_subdirectory_exist
      save_current_snapshot
    rescue Errno::ENETUNREACH
      remove_file
    end

    private

    def now
      @now ||= Time.now
    end

    def subdirectory
      "#{Settings.steve_snapshotter.directory}/#{now.strftime('%Y-%m-%d')}"
    end

    def file_name
      "#{now.strftime('%H%M%S')}.jpg"
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
      File.open(file_path, 'wb') do |file|
        file << Net::HTTP.get(URI.parse(URI.escape(Settings.steve_snapshotter.url)))
      end
    end

    def remove_file
      File.delete(file_path) if File.exist?(file_path)
    end
  end
end
