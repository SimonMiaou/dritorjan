require 'entry'
require 'file_iterator'
require 'sys/filesystem'

class Dritorjan
  def self.scan_files
    config['directories'].each do |path|
      FileIterator.new(path).scan do |file|
        Entry.register(file)
      end
    end
  end

  def self.remove_before(time)
    Entry.where('updated_at < ?', time).delete_all
  end

  def self.free_space
    while o_available < config['min_free_space'] do
      Entry.order(mtime: :asc).limit(1).first.delete_file
    end
  end

  private

  def self.config
    return @config if @config
    config_path = ROOT_PATH + '/config.json'
    @config = JSON.parse(File.read(config_path))
  end

  def self.o_available
    stat = Sys::Filesystem.stat(config['root_path'])
    stat.block_size * stat.blocks_available
  end
end
