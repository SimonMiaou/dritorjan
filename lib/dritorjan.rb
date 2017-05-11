require 'entry'
require 'file_iterator'
require 'sys/filesystem'

class Dritorjan
  def self.free_space
    while o_available < config['min_free_space']
      Entry.order(mtime: :asc).limit(1).first.delete_file
    end
  end

  def self.o_available
    stat = Sys::Filesystem.stat(config['root_path'])
    stat.block_size * stat.blocks_available
  end
  private_class_method :o_available
end
