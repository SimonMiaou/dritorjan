require 'dritorjan'
require 'dritorjan/initializers/sidekiq'

module Dritorjan
  module Jobs
    class DirectorySizeUpdater
      include Sidekiq::Worker

      def perform(path)
        dir = Models::DirEntry.find path
        dir.update!(size: dir.entries.sum(:size))
      rescue ActiveRecord::RecordNotFound => e
        Dritorjan.logger.error(e.message)
      end
    end
  end
end
