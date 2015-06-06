require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'dritorjan.sqlite3')
require 'schema'

class Entry < ActiveRecord::Base
  def self.register(file_path)
    file = File.new(file_path)
    stat = file.lstat

    entry = Entry.where(file_path: file_path).first
    entry ||= Entry.new(file_path: file_path)
    entry.file_path = file_path
    entry.dirname   = File.dirname(file_path)
    entry.basename  = File.basename(file_path)
    entry.mtime     = stat.mtime
    entry.size      = stat.size
    entry.new_record? ? entry.save! : entry.touch
  end

  def self.search(q)
    keywords = q.gsub(/\W/, ' ').split(' ')
    where("file_path like '%#{keywords.join('%')}%'")
  end

  def as_json(options = {})
    {
      file_path: file_path,
      dirname:   dirname,
      basename:  basename,
      mtime:     mtime,
      size:      size
    }
  end
end
