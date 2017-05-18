require 'test_helper'
require 'dritorjan/jobs/files_remover'

module Dritorjan
  module Jobs
    class TestFilesRemover < Minitest::Test
      def setup
        super

        FileUtils.rm_rf('tmp/files_remover')
        Dir.mkdir('tmp/files_remover')

        Models::Entry.destroy_all
      end

      def test_delete_files_to_free_space
        oldest_entry = create(:file_entry, path: create_file,
                                           mtime: 1.day.ago,
                                           size: block_size)
        newest_entry = create(:file_entry, path: create_file,
                                           mtime: 1.minute.ago,
                                           size: block_size)
        middle_entry = create(:file_entry, path: create_file,
                                           mtime: 1.hour.ago,
                                           size: block_size)

        blocks_available = Settings.file_manager.min_free_space / block_size
        blocks_availables = []
        blocks_availables << blocks_available - 1 # not enough space
        blocks_availables << blocks_available - 1 # not enough space
        blocks_availables << blocks_available + rand(2) # enough space

        mock(Sys::Filesystem).stat('./tmp').times(blocks_availables.size) do
          OpenStruct.new(block_size: block_size,
                         blocks_available: blocks_availables.shift)
        end

        FilesRemover.new.perform

        refute File.exist?(oldest_entry.path)
        refute File.exist?(middle_entry.path)
        assert File.exist?(newest_entry.path)
      end

      def test_doesnt_infinite_loop_if_no_more_file
        entry = create(:file_entry, path: create_file)

        mock(Sys::Filesystem).stat('./tmp').times(2) { OpenStruct.new(block_size: 8, blocks_available: 0) }

        FilesRemover.new.perform

        assert_equal 0, Models::FileEntry.count
        refute File.exist?(entry.path)
      end

      def test_doesnt_delete_file_if_enough_space
        entry = create(:file_entry, path: create_file,
                                    mtime: Time.now,
                                    size: rand(999))

        blocks_available = Settings.file_manager.min_free_space / block_size
        mock(Sys::Filesystem).stat('./tmp') { OpenStruct.new(block_size: block_size, blocks_available: blocks_available) }

        FilesRemover.new.perform

        assert_equal 1, Models::FileEntry.count
        assert File.exist?(entry.path)
      end

      private

      def create_file
        file_path = Faker::File.file_name('tmp/files_remover')
        File.open(file_path, 'wb') { |file| file << Faker::Cat.name }
        file_path
      end

      def block_size
        @block_size ||= [1, 2, 4, 8, 16].sample
      end
    end
  end
end
