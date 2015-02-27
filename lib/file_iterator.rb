class FileIterator
  def initialize(path)
    @path = path
  end

  def scan(&blk)
    if dir?
      each_sub_path do |sub_path|
        self.class.new("#{@path}/#{sub_path}").scan(&blk)
      end
    elsif file?
      blk.call @path
    end
  end

  private

  def dir?
    Dir.exist?(@path)
  end

  def file?
    File.exist?(@path)
  end

  def each_sub_path(&blk)
    raise "#{path} is not a directory" unless dir?

    dir = Dir.new(@path)
    dir.each do |sub_path|
      next if sub_path == '.' || sub_path == '..'
      blk.call sub_path
    end
  end
end
