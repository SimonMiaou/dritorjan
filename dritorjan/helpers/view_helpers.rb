module Dritorjan
  module Helpers
    module ViewHelpers
      def breadcrumb(entry)
        b = ''

        while entry.path != '/'
          link = "<a href=\"#{Addressable::URI.encode(entry.path)}\">#{entry.basename}</a>"
          b = "/#{link}#{b}"
          entry = entry.parent
        end

        b
      end
    end
  end
end
