require 'dritorjan/database'

Dritorjan::Database.connect

module Dritorjan
  module Models
    class Entry < ActiveRecord::Base
      self.table_name = :entries
      self.primary_key = :path

      belongs_to :parent, class_name: 'DirEntry', foreign_key: :dirname

      def self.register(path)
        if Dir.exist?(path)
          DirEntry.register(path)
        else
          FileEntry.register(path)
        end
      end

      def dir?
        is_a? DirEntry
      end

      def file?
        is_a? FileEntry
      end
    end

    class DirEntry < Entry
      has_many :entries, foreign_key: :dirname

      def self.register(path)
        path = File.realpath(path)
        file = File.new(path)

        entry = find_or_initialize_by(path: path)
        entry.size ||= 0
        entry.update(dirname: File.dirname(path),
                     basename: File.basename(path),
                     mtime: file.lstat.mtime)
        entry
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
        file = File.new(path)
        stat = file.lstat

        entry = find_or_initialize_by(path: path)
        entry.update(dirname: File.dirname(path),
                     basename: File.basename(path),
                     mtime: stat.mtime,
                     size: stat.size)
        entry
      end
    end
  end
end
