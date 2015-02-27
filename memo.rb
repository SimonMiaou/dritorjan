# http://stackoverflow.com/questions/4508692/get-available-diskspace-in-ruby
require 'sys/filesystem'
stat = Sys::Filesystem.stat("/")
mb_available = stat.block_size * stat.blocks_available / 1024 / 1024
