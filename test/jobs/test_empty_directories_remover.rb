require 'test_helper'
require 'dritorjan/jobs/empty_directories_remover'

module Dritorjan
  module Jobs
    class TestEmptyDirectoriesRemover < Minitest::Test
      def test_remove_empty_directories
        FileUtils.rm_rf('./tmp')
        Dir.mkdir('./tmp')
        Dir.mkdir('./tmp/empty_directory')

        EmptyDirectoriesRemover.new.perform

        assert Dir.exist?('./tmp'), 'didn\'t remove configured directory'
        refute Dir.exist?('./tmp/empty_directory'), 'removed empty directory'
      end
    end
  end
end
