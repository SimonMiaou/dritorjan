require 'dritorjan/database'

Dritorjan::Database.connect

module Dritorjan
  module Models
    class Entry < ActiveRecord::Base
      self.table_name = 'entries'

      def self.register(path)
        file = File.new(path)
        stat = file.lstat

        entry = Entry.find_or_initialize_by(path: path)
        entry.update(dirname: File.dirname(path),
                     basename: File.basename(path),
                     mtime: stat.mtime,
                     size: stat.size)
      end
    end
  end
end
