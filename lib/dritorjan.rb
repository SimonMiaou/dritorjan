require 'entry'
require 'file_iterator'

class Dritorjan
  def self.scan_files(dir)
    FileIterator.new(dir).scan do |file|
      Entry.register(file)
    end
  end

  def self.remove_before(time)
    Entry.where('updated_at < ?', time).delete_all
  end
end
