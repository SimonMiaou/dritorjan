require 'test_helper'
require 'dritorjan/jobs/files_scanner'

module Dritorjan
  module Jobs
    class TestFilesScanner < Minitest::Test
      def setup
        super
        Models::Entry.destroy_all
      end

      def test_scan_parents_to_root_path
        FilesScanner.new.perform

        assert Models::Entry.find_by(path: '/'), 'register /'
        assert_equal 1, Models::Entry.find_by(path: '/').entries.count, 'root has only one entry'
        refute Models::Entry.find_by(path: File.realpath('./dritorjan')), 'doesn\'t scan the hole system'
      end
    end
  end
end
