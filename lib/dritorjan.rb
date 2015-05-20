require 'entry'
require 'file_iterator'

class Dritorjan
  def self.scan_files(dir)
    FileIterator.new(dir).scan do |file|
      Entry.register(file)
    end
  end
end
