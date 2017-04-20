require 'test_helper'
require 'dritorjan/jobs/directory_size_updater'

module Dritorjan
  module Jobs
    class TestDirectorySizeUpdater < Minitest::Test
      def setup
        super

        Models::Entry.destroy_all
      end

      def test_update_size_of_the_directory_with_the_sum_of_the_entries_size
        root_path = File.realpath('.')
        dir = Models::DirEntry.create!(path: "#{root_path}/tmp",
                                       dirname: '/Users/simon/Github/SimonMiaou/dritorjan',
                                       basename: 'tmp',
                                       mtime: Time.now,
                                       size: 0,
                                       scanned_at: Time.now)
        file_foo = Models::FileEntry.create!(path: "#{root_path}/tmp/foo.txt",
                                             dirname: dir.path,
                                             basename: 'foo.txt',
                                             mtime: Time.now,
                                             size: rand(999),
                                             scanned_at: Time.now)
        file_bar = Models::FileEntry.create!(path: "#{root_path}/tmp/bar.txt",
                                             dirname: dir.path,
                                             basename: 'bar.txt',
                                             mtime: Time.now,
                                             size: rand(999),
                                             scanned_at: Time.now)

        assert_equal 0, dir.reload.size
        DirectorySizeUpdater.new.perform dir.path
        assert_equal (file_foo.size + file_bar.size), dir.reload.size
      end
    end
  end
end
