require 'rake'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')

task :scan do
  require 'file_iterator'

  FileIterator.new('/home/simon/Desktop').scan do |file|
    puts file
  end
end
