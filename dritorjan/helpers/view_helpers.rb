require 'shellwords'

module Dritorjan
  module Helpers
    module ViewHelpers
      def breadcrumb(entry)
        b = ''

        while entry.path != '/'
          link = "<a href=\"#{entry_url(entry)}\">#{entry.basename}</a>"
          b = "/#{link}#{b}"
          entry = entry.parent
        end

        b
      end

      def build_scp_command(entry)
        escaped_path = Shellwords.escape(Shellwords.escape(entry.path))

        command = ['scp']
        command << '-r' if entry.dir?
        command << "#{current_user.login}@#{Settings.host}:#{escaped_path}"
        command << './'
        command.join(' ')
      end

      def entry_url(entry)
        "/entries#{Addressable::URI.encode(entry.path)}"
      end
    end
  end
end
