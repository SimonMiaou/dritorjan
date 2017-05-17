require 'dritorjan'
require 'dritorjan/initializers/sidekiq'
require 'dritorjan/models/entry'
require 'sys/filesystem'

module Dritorjan
  module Jobs
    class FilesRemover
      include Sidekiq::Worker

      def perform
        delete_oldest_file_entry until enough_space? || no_more_file_entries?
      end

      private

      def enough_space?
        o_available >= Settings.file_manager.min_free_space
      end

      def no_more_file_entries?
        Models::FileEntry.count.zero?
      end

      def o_available
        stat = Sys::Filesystem.stat(Settings.file_manager.root_directory)
        stat.block_size * stat.blocks_available
      end

      def delete_oldest_file_entry
        Models::FileEntry.order(mtime: :asc).limit(1).first.delete_file
      end
    end
  end
end
