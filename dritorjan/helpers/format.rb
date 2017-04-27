module Dritorjan
  module Helpers
    module Format
      def format_size(size)
        if size > 1_000_000_000
          size = (size.to_f / 1_000_000_000).round(2)
          "#{size} Go"
        elsif size > 1_000_000
          size = (size.to_f / 1_000_000).round(2)
          "#{size} Mo"
        elsif size > 1_000
          size = (size.to_f / 1_000).round(2)
          "#{size} Ko"
        else
          "#{size} o"
        end
      end
    end
  end
end
