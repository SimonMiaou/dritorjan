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

      def entry_url(entry)
        "/entries#{Addressable::URI.encode(entry.path)}"
      end
    end
  end
end
