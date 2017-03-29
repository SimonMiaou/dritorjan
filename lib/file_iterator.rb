require 'dritorjan'

class FileIterator
  def initialize(path)
    @path = path
  end

  def scan(&blk)
    if dir?
      sub_paths.each do |sub_path|
        self.class.new("#{@path}/#{sub_path}").scan(&blk)
      end
      remove_dir if sub_paths.empty?
    elsif file?
      yield @path
    end
  end

  private

  def dir?
    Dir.exist?(@path)
  end

  def file?
    File.exist?(@path)
  end

  def sub_paths
    raise "#{@path} is not a directory" unless dir?
    return @sub_paths if @sub_paths

    @sub_paths = []
    dir = Dir.new(@path)
    dir.each do |sub_path|
      next if sub_path == '.' || sub_path == '..'
      @sub_paths << sub_path
    end

    @sub_paths
  end

  def remove_dir
    return if Dritorjan.config['directories'].include?(@path)
    Dir.delete(@path)
  end
end
