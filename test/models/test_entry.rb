require 'test_helper'
require 'dritorjan/models/entry'

module Dritorjan
  module Models
    class TestEntry < Minitest::Test
      def setup
        super

        @dirname = './tmp'
        @basename = 'test_entry_file.txt'
        @file_path = "#{@dirname}/#{@basename}"

        Entry.destroy_all
      end

      def test_register_an_entry_with_the_file_informations
        create_default_file

        Dritorjan::Models::Entry.register(@file_path)

        entry = Entry.first
        assert_equal @file_path, entry.path
        assert_equal @dirname, entry.dirname
        assert_equal @basename, entry.basename
        assert_equal @file_content.size, entry.size
      end

      def test_register_update_file_information
        assert_equal 0, Entry.count

        create_default_file
        Dritorjan::Models::Entry.register(@file_path)
        assert_equal 1, Entry.count, 'create the entry'

        create_default_file
        Dritorjan::Models::Entry.register(@file_path)
        assert_equal 1, Entry.count, 'doesnt create another entry'

        entry = Entry.first
        assert_equal @file_content.size, entry.size, 'size match the new content'
      end

      private

      def create_default_file
        @file_content = Faker::Cat.name
        File.open(@file_path, 'wb') { |file| file << @file_content }
      end
    end
  end
end
