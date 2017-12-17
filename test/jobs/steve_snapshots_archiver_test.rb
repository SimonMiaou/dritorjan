require 'test_helper'
require 'dritorjan/jobs/steve_snapshots_archiver'

module Dritorjan
  module Jobs
    class SteveSnapshotsArchiverTest < Minitest::Test
      def setup
        super

        FileUtils.rm_rf(Settings.steve_snapshotter.directory)
        Dir.mkdir(Settings.steve_snapshotter.directory)
      end

      def test_archive_old_sub_directories
        yesterdays_directory_path = "#{Settings.steve_snapshotter.directory}/#{1.day.ago.utc.strftime('%Y-%m-%d')}"
        todays_directory_path = "#{Settings.steve_snapshotter.directory}/#{Time.now.utc.strftime('%Y-%m-%d')}"

        Dir.mkdir(yesterdays_directory_path)
        create_file("#{yesterdays_directory_path}/foo.txt")
        Dir.mkdir(todays_directory_path)
        create_file("#{todays_directory_path}/foo.txt")

        SteveSnapshotsArchiver.new.perform

        refute Dir.exist?(yesterdays_directory_path)
        assert File.exist?("#{yesterdays_directory_path}.zip")
        assert Dir.exist?(todays_directory_path)
      end

      def test_doesnt_archive_files
        create_file("#{Settings.steve_snapshotter.directory}/foo.txt")

        SteveSnapshotsArchiver.new.perform

        assert File.exist?("#{Settings.steve_snapshotter.directory}/foo.txt")
      end

      private

      def create_file(file_path)
        File.open(file_path, 'wb') { |file| file << Faker::Cat.name }
      end
    end
  end
end
