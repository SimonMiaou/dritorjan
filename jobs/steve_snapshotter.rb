require 'net/http'
require 'uri'
require 'sidekiq'

class SteveSnapshotter
  include Sidekiq::Worker

  def perform
    ensure_directory_exist
    save_current_snapshot
  end

  private

  def ensure_directory_exist
    Dir.mkdir(Settings.steve_snapshotter.directory) unless Dir.exist?(Settings.steve_snapshotter.directory)
  end

  def save_current_snapshot
    File.open(file_path, 'wb') do |file|
      file << Net::HTTP.get(URI.parse(URI.escape(Settings.steve_snapshotter.url)))
    end
  end

  def file_path
    "#{Settings.steve_snapshotter.directory}/#{Time.now.strftime('%Y-%m-%d-%H%M%S')}.jpg"
  end
end
