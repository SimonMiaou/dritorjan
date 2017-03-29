require 'active_record'

ActiveRecord::Base.establish_connection(
  JSON.parse(File.read(ROOT_PATH + '/database.json'))
)
require 'schema'

class Entry < ActiveRecord::Base
  def self.register(file_path)
    file = File.new(file_path)
    stat = file.lstat

    entry = Entry.where(file_path: file_path).first
    entry ||= Entry.new(file_path: file_path)
    entry.dirname   = File.dirname(file_path)
    entry.basename  = File.basename(file_path)
    entry.mtime     = stat.mtime
    entry.size      = stat.size
    entry.new_record? ? entry.save! : entry.touch
  end

  def self.search(q)
    q ||= ''
    keywords = q.gsub(/\W/, ' ').split(' ')
    where("LOWER(file_path) like LOWER('%#{keywords.join('%')}%')")
  end

  def delete_file
    File.delete(file_path)
    destroy
  rescue Errno::EACCES
    Logger.new(STDOUT).info(e.message)
  end

  def as_json(_options = {})
    {
      file_path: file_path,
      dirname:   dirname,
      basename:  basename,
      mtime:     mtime,
      size:      size
    }
  end
end
