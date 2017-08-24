require 'dritorjan'
require 'dritorjan/initializers/sidekiq'
require 'zip'

module Dritorjan
  module Jobs
    class SteveSnapshotsArchiver
      include Sidekiq::Worker

      def perform
        return unless Dir.exist?(Settings.steve_snapshotter.directory)

        Dir.entries(Settings.steve_snapshotter.directory).each do |entry|
          next if ['.', '..', now_to_s].include?(entry)

          full_path = "#{Settings.steve_snapshotter.directory}/#{entry}"
          next unless Dir.exist?(full_path)

          archive_and_remove(full_path)
        end
      end

      private

      def now_to_s
        @now_to_s ||= Time.now.utc.strftime('%Y-%m-%d')
      end

      def archive_and_remove(folder)
        Zip::File.open("#{folder}.zip", Zip::File::CREATE) do |zipfile|
          Dir.entries(folder).each do |filename|
            next if ['.', '..'].include?(filename)
            zipfile.add(filename, File.join(folder, filename))
          end
        end
        FileUtils.rm_rf(folder)
      end
    end
  end
end
