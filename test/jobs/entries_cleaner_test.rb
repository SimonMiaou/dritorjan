require 'test_helper'
require 'dritorjan/jobs/entries_cleaner'

module Dritorjan
  module Jobs
    class EntriesCleanerTest < Minitest::Test
      def setup
        super
        Models::Entry.destroy_all
      end

      def test_delete_old_entries
        old_entry = create(:entry, scanned_at: (Settings.file_manager.old_entries_threshold_in_minutes + 1).minutes.ago)
        recent_entry = create(:entry, scanned_at: (Settings.file_manager.old_entries_threshold_in_minutes - 1).minutes.ago)

        EntriesCleaner.new.perform

        refute Models::Entry.find_by_path(old_entry.path), 'removed old entry'
        assert Models::Entry.find_by_path(recent_entry.path), 'kept recent entry'
      end
    end
  end
end
