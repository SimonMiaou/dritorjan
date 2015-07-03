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
    while o_available < config['min_free_space']
      Entry.order(mtime: :asc).limit(1).first.delete_file
    end
  end

  def self.auto_remove
    config['auto_remove'].each do |where_clause|
      Entry.where(where_clause).each do |entry|
        puts entry.file_path
        entry.delete_file
      end
    end
  end

  def self.config
    return @config if @config
    config_path = ROOT_PATH + '/config.json'
    @config = JSON.parse(File.read(config_path))
  end

  private

  def self.o_available
    stat = Sys::Filesystem.stat(config['root_path'])
    stat.block_size * stat.blocks_available
  end
end
