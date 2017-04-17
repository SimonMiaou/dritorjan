require 'dritorjan'
require 'dritorjan/initializers/sidekiq'
require 'dritorjan/models/entry'

module Dritorjan
  module Jobs
    class DirectorySizeUpdater
      include Sidekiq::Worker

      def perform(path)
        dir = Models::DirEntry.find path
        dir.update!(size: dir.entries.pluck(:size).sum)
      end
    end
  end
end
