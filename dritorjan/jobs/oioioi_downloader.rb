require 'dritorjan'
require 'dritorjan/initializers/sidekiq'
require 'net/http'
require 'nokogiri'
require 'uri'

module Dritorjan
  module Jobs
    class OioioiDownloader
      include Sidekiq::Worker

      URL = 'http://oioioi.ru/mp3/skinhead/moonstomp.html'.freeze
      REGEX = %r{\Ahttp://www\.skinhead\.ru/mp3/(.*\.mp3)\z}i

      def perform
        ensure_directory_exist(Settings.oioioi.directory)

        mp3_urls.each do |mp3_url|
          file_path = "#{Settings.oioioi.directory}/#{mp3_url.match(REGEX)[1]}"
          next if File.exist?(file_path)

          ensure_directory_exist(File.dirname(file_path))
          download_file(mp3_url, file_path)
        end
      rescue Net::OpenTimeout => e
        Dritorjan.logger.error(e.message)
      end

      private

      def ensure_directory_exist(dir)
        Dir.mkdir(dir) unless Dir.exist?(dir)
      end

      def mp3_urls
        raw_html = Net::HTTP.get(URI.parse(URL))
        web_page = Nokogiri::HTML(raw_html)
        links = web_page.css('a').map { |l| l['href'] }
        links.compact.uniq.select { |url| url.match REGEX }
      end

      def download_file(url, file_path)
        Dritorjan.logger.info("Downloading #{url}")
        file_body = Net::HTTP.get(URI.parse(URI.escape(url)))
        File.open(file_path, 'wb') do |file|
          file << file_body
        end
      end
    end
  end
end
