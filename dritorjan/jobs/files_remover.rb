require 'dritorjan'
require 'dritorjan/initializers/sidekiq'
require 'dritorjan/models/entry'
require 'sys/filesystem'

module Dritorjan
  module Jobs
    class FilesRemover
      include Sidekiq::Worker

      def perform
        delete_oldest_entry until enough_space?
      end

      private

      def enough_space?
        o_available >= Settings.file_manager.min_free_space
      end

      def o_available
        stat = Sys::Filesystem.stat(Settings.file_manager.root_directory)
        stat.block_size * stat.blocks_available
      end

      def delete_oldest_entry
        Models::Entry.order(mtime: :asc).limit(1).first.delete_file
      end
    end
  end
end
