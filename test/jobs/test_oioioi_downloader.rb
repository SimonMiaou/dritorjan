require 'test_helper'
require 'dritorjan/jobs/oioioi_downloader'

module Dritorjan
  module Jobs
    class TestOioioiDownloader < Minitest::Test
      def setup
        super
        FileUtils.rm_rf(Settings.oioioi.directory)
      end

      def test_download_steve_snapshot
        web_page_body = File.read('./test/fixtures/oioioi/moonstomp.html')
        stub_request(:get, OioioiDownloader::URL).to_return(body: web_page_body)

        stub_file_request('rocksteady/Derrick Morgan - Take It Easy.mp3')
        stub_file_request('punk/Smodati - Il Ritorno Degli Smodati!.mp3')

        OioioiDownloader.new.perform

        assert_downloaded_file('rocksteady/Derrick Morgan - Take It Easy.mp3')
        assert_downloaded_file('punk/Smodati - Il Ritorno Degli Smodati!.mp3')
      end

      private

      def stub_file_request(file_name)
        stub_request(:get, "http://www.skinhead.ru/mp3/#{file_name}").to_return(body: File.read("./test/fixtures/oioioi/#{file_name}"))
      end

      def assert_downloaded_file(file_name)
        assert_equal File.read("./test/fixtures/oioioi/#{file_name}"), File.read("./tmp/oioioi/#{file_name}")
      end
    end
  end
end
