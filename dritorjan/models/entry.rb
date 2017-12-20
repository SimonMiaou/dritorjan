require 'dritorjan/database'
require 'dritorjan/jobs/directory_size_updater'

Dritorjan::Database.connect

module Dritorjan
  module Models
    class Entry < ActiveRecord::Base
      self.table_name = :entries
      self.primary_key = :path

      belongs_to :parent, class_name: 'DirEntry', foreign_key: :dirname

      validates :path, :dirname, :basename, :mtime, :size, :scanned_at, presence: true

      after_commit :update_parent_size
      before_save do
        @size_changed = size_changed?
        true
      end

      scope :old, -> { where('scanned_at < ?', Settings.file_manager.old_entries_threshold_in_minutes.minutes.ago) }

      def self.register(path)
        if Dir.exist?(path)
          DirEntry.register(path)
        else
          FileEntry.register(path)
        end
      rescue Errno::ENOENT => e
        Dritorjan.logger.error(e.message)
        nil
      end

      def dir?
        is_a? DirEntry
      end

      def file?
        is_a? FileEntry
      end

      def register_parent
        Entry.register(dirname)
      end

      private

      def update_parent_size
        Jobs::DirectorySizeUpdater.perform_async(dirname) if destroyed? || defined?(@size_changed) && @size_changed
      end
    end

    class DirEntry < Entry
      has_many :entries, -> { where.not(path: '/') }, foreign_key: :dirname

      def self.register(path)
        path = File.realpath(path)

        dir_entry = find_or_initialize_by(path: path)
        dir_entry.size ||= dir_entry.entries.sum(:size)
        dir_entry.update(dirname: File.dirname(path),
                         basename: File.basename(path),
                         mtime: File.mtime(path),
                         scanned_at: Time.now)
        dir_entry
      end

      def register_content
        entries = Dir.entries(path).reject { |path| path == '.' || path == '..' }

        entries.each do |entry_path|
          entry = Models::Entry.register("#{path}/#{entry_path}")
          entry.register_content if entry.dir?
        end
      end
    end

    class FileEntry < Entry
      def self.register(path)
        path = File.realpath(path)

        file_entry = find_or_initialize_by(path: path)
        file_entry.update(dirname: File.dirname(path),
                          basename: File.basename(path),
                          mtime: File.mtime(path),
                          size: File.size(path),
                          scanned_at: Time.now)
        file_entry
      end

      def delete_file
        File.delete path
        destroy
      end
    end
  end
end
