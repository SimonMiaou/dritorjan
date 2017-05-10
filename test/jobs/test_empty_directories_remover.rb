require 'test_helper'
require 'dritorjan/jobs/empty_directories_remover'

module Dritorjan
  module Jobs
    class TestEmptyDirectoriesRemover < Minitest::Test
      def setup
        super

        FileUtils.rm_rf('./tmp')
        Dir.mkdir('./tmp')
      end

      def test_remove_empty_directories
        Dir.mkdir('./tmp/empty_directory')

        EmptyDirectoriesRemover.new.perform

        assert Dir.exist?('./tmp'), 'didn\'t remove configured directory'
        refute Dir.exist?('./tmp/empty_directory'), 'removed empty directory'
      end

      def test_remove_recursively
        Dir.mkdir('./tmp/directory_with_empty_sub_directory')
        Dir.mkdir('./tmp/directory_with_empty_sub_directory/empty_directory')

        EmptyDirectoriesRemover.new.perform

        refute Dir.exist?('./tmp/directory_with_empty_sub_directory')
      end

      def test_keep_directories_with_content
        Dir.mkdir('./tmp/directory')
        File.open('./tmp/directory/file', 'wb') { |file| file << Faker::Cat.name }

        EmptyDirectoriesRemover.new.perform

        assert Dir.exist?('./tmp/directory')
      end
    end
  end
end
