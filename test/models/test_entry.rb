require 'test_helper'
require 'dritorjan/models/entry'
require 'factories/entry'

module Dritorjan
  module Models
    class TestEntry < Minitest::Test
      def setup
        super

        Entry.destroy_all
      end

      def test_factory_set_dirname_and_basename
        entry = create(:entry, path: '/home/user/.bash_profile')
        assert_equal '/home/user', entry.dirname
        assert_equal '.bash_profile', entry.basename
      end

      def test_register_an_entry_with_the_file_informations
        create_default_file

        Entry.register(@file_path)

        entry = Entry.first
        assert_equal @file_path, entry.path
        assert_equal @dirname, entry.dirname
        assert_equal @basename, entry.basename
        assert_equal @file_content.size, entry.size
      end

      def test_register_update_file_information
        assert_equal 0, Entry.count

        create_default_file
        Entry.register(@file_path)
        assert_equal 1, Entry.count, 'create the entry'

        create_default_file
        Entry.register(@file_path)
        assert_equal 1, Entry.count, 'doesnt create another entry'

        entry = Entry.first
        assert_equal @file_content.size, entry.size, 'size match the new content'
      end

      def test_update_size_of_parent_when_size_change
        dirname = File.realpath('./tmp')

        mock(Jobs::DirectorySizeUpdater).perform_async(dirname)
        file = create(:file_entry, path: "#{dirname}/foo.txt")

        mock(Jobs::DirectorySizeUpdater).perform_async(dirname)
        file.update(size: rand(999))

        file.update(mtime: Time.now - 1.hour)

        mock(Jobs::DirectorySizeUpdater).perform_async(dirname)
        file.destroy
      end

      def test_register_update_scanned_at
        create_default_file
        entry = Entry.register(@file_path)

        assert entry.scanned_at, 'set scanned_at'
        scanned_at = entry.scanned_at

        entry = Entry.register(@file_path)
        refute_equal scanned_at, entry.scanned_at, 'update the scanned_at'
      end

      private

      def create_default_file
        @dirname = File.realpath('./tmp')
        @basename = 'test_entry_file.txt'
        @file_path = "#{@dirname}/#{@basename}"

        @file_content = Faker::Cat.name
        File.open(@file_path, 'wb') { |file| file << @file_content }
      end
    end

    class TestDirEntry < Minitest::Test
      def setup
        super

        @dir_path = './tmp/file_manager'

        Entry.destroy_all
        reset_test_files

        @dir_path = File.realpath(@dir_path)
      end

      def test_register_content
        dir = Entry.register(@dir_path)
        dir.register_content

        entries_paths = ["#{@dir_path}/foo.txt", "#{@dir_path}/bar.txt", "#{@dir_path}/sub"]
        assert_equal entries_paths.sort, dir.entries.pluck(:path).sort

        entry = Entry.find "#{@dir_path}/sub/file.txt"
        assert_equal "#{@dir_path}/sub", entry.parent.path
        assert_equal @dir_path, entry.parent.parent.path
      end

      def test_update_size_from_entries_when_created
        entry_foo = create(:file_entry)
        entry_bar = create(:file_entry, dirname: entry_foo.dirname)
        parent = Entry.register(entry_foo.dirname)

        assert_equal (entry_foo.size + entry_bar.size), parent.size, 'size is the sum of entries sizes'
      end

      private

      def reset_test_files
        FileUtils.rm_rf(@dir_path)
        Dir.mkdir(@dir_path)

        create_file("#{@dir_path}/foo.txt")
        create_file("#{@dir_path}/bar.txt")
        Dir.mkdir("#{@dir_path}/sub")
        create_file("#{@dir_path}/sub/file.txt")
      end

      def create_file(file_path)
        File.open(file_path, 'wb') { |file| file << Faker::Cat.name }
      end
    end
  end
end
