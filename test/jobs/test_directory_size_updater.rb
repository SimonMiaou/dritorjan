require 'test_helper'
require 'dritorjan/jobs/directory_size_updater'
require 'factories/entry'

module Dritorjan
  module Jobs
    class TestDirectorySizeUpdater < Minitest::Test
      def setup
        super

        Models::Entry.destroy_all
      end

      def test_update_size_of_the_directory_with_the_sum_of_the_entries_size
        root_path = File.realpath('.')
        dir = create(:dir_entry, path: "#{root_path}/tmp",
                                 size: 0)
        file_foo = create(:file_entry, path: "#{root_path}/tmp/foo.txt")
        file_bar = create(:file_entry, path: "#{root_path}/tmp/bar.txt")

        assert_equal 0, dir.reload.size
        DirectorySizeUpdater.new.perform dir.path
        assert_equal (file_foo.size + file_bar.size), dir.reload.size
      end
    end
  end
end
