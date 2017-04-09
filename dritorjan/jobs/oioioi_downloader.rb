require 'dritorjan/initializers/sidekiq'
require 'net/http'
require 'nokogiri'
require 'uri'

module Dritorjan
  module Jobs
    class OioioiDownloader
      include Sidekiq::Worker

      URL = 'http://oioioi.ru/mp3/skinhead/moonstomp.html'.freeze
      REGEX = %r{/\Ahttp:\/\/www\.skinhead\.ru\/mp3\/(.*\.mp3)\z/i}

      def perform
        ensure_directory_exist

        page = Nokogiri::HTML(Net::HTTP.get(URI.parse(URL)))
        links = page.css('a')
        hrefs = links.map { |l| l['href'] }.compact
        mp3_hrefs = hrefs.select { |url| url.match REGEX }

        mp3_hrefs.each do |href|
          path = href.match(regex)[1]
          save(href, folder + path)
        end
      rescue Net::OpenTimeout
      end

      private

      def ensure_directory_exist
        Dir.mkdir(Settings.oioioi.directory) unless Dir.exist?(Settings.oioioi.directory)
      end

      def save(url, path)
        if File.exist?(path)
          puts "Already saved: #{url}"
          return
        end

        puts "Downloading: #{url}"

        dir = File.dirname(path)
        Dir.mkdir(dir) unless Dir.exist?(dir)

        File.open(path, 'wb') do |file|
          file << Net::HTTP.get(URI.parse(url))
        end

        puts "Saved in: #{path}"
      end
    end
  end
end
