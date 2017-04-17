require 'dritorjan/database'

Dritorjan::Database.connect

module Dritorjan
  module Models
    class Entry < ActiveRecord::Base
      self.table_name = :entries
      self.primary_key = :path

      def self.register(path)
        path = File.realpath(path)
        puts "Register #{path}"
        file = File.new(path)
        stat = file.lstat

        entry = Entry.find_or_initialize_by(path: path)
        entry.update(dirname: File.dirname(path),
                     basename: File.basename(path),
                     mtime: stat.mtime,
                     size: stat.size)
        entry
      end

      def dir?
        Dir.exist?(path)
      end

      def file?
        File.exist?(path)
      end

      def register_content
        entries = Dir.entries(path).reject { |path| path == '.' || path == '..' }

        entries.each do |entry_path|
          entry = Models::Entry.register("#{path}/#{entry_path}")
          entry.register_content if entry.dir?
        end
      end
    end
  end
end
