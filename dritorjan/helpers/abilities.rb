require 'dritorjan'
require 'dritorjan/models/user'

module Dritorjan
  module Helpers
    module Abilities
      def can_scan?(entry)
        Settings.file_manager.directories
                .select { |path| Dir.exist?(path) }
                .any? { |path| entry.path.include?(File.realpath(path)) }
      end
    end
  end
end
