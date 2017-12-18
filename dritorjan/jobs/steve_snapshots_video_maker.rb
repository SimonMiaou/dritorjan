require 'dritorjan'
require 'dritorjan/initializers/sidekiq'
require 'zip'

module Dritorjan
  module Jobs
    class SteveSnapshotsVideoMaker
      include Sidekiq::Worker

      TMP_FOLDER_PATH = './tmp/steve_snapshots_video_maker'.freeze

      def perform
        return unless Dir.exist?(Settings.steve_snapshotter.directory)

        ensure_clean_tmp_directory

        Dir.entries(Settings.steve_snapshotter.directory)
           .each do |entry|
             regex = entry.match(/\A(\d{4}-\d{2}-\d{2})\.zip\z/i)
             next if regex.nil?
             key = regex[1]

             zip_path = "#{Settings.steve_snapshotter.directory}/#{entry}"
             tmp_folder_path = "#{TMP_FOLDER_PATH}/#{key}"
             video_output_path = "#{Settings.steve_snapshotter.directory}/#{key}.mp4"

             next if File.exist?(video_output_path)

             Dir.mkdir(tmp_folder_path)
             unzip(zip_path, tmp_folder_path)
             rename_files(tmp_folder_path)
             make_video(tmp_folder_path, video_output_path)
           end
      end

      private

      def ensure_clean_tmp_directory
        Dir.mkdir('./tmp') unless Dir.exist?('./tmp')
        FileUtils.rm_rf(TMP_FOLDER_PATH) if Dir.exist?(TMP_FOLDER_PATH)
        Dir.mkdir(TMP_FOLDER_PATH)
      end

      def unzip(zip_path, folder_path)
        Zip::File.open(zip_path) do |zip_file|
          zip_file.each do |entry|
            dest_file = "#{folder_path}/#{entry.name}"
            entry.extract(dest_file)
          end
        end
      end

      def rename_files(folder_path)
        entries = Dir.entries(folder_path).reject { |entry| entry == '.' || entry == '..' }

        i = 0
        entries.sort.each do |entry|
          old_path = "#{folder_path}/#{entry}"
          new_path = "#{folder_path}/#{i.to_s.rjust(5, '0')}.jpg"
          File.rename(old_path, new_path)
          i += 1
        end
      end

      def make_video(input_path, output_path)
        `ffmpeg -framerate 24 -i #{input_path}/%05d.jpg #{output_path}`
      end
    end
  end
end
