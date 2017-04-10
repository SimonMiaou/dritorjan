require 'test_helper'
require 'dritorjan/jobs/steve_snapshotter'

module Jobs
  class TestSteveSnapshotter < Minitest::Test
    def setup
      super

      @now = Time.now
      @file_path = "#{Settings.steve_snapshotter.directory}/#{@now.strftime('%Y-%m-%d')}/#{@now.strftime('%H-%M-%S-%L')}.jpg"

      FileUtils.rm_rf(Settings.steve_snapshotter.directory)
    end

    def test_download_steve_snapshot
      steve_raw = File.read('./test/fixtures/steve.png')

      stub(Time).now { @now }
      stub_request(:get, Settings.steve_snapshotter.url).to_return(body: steve_raw)

      Dritorjan::Jobs::SteveSnapshotter.new.perform

      assert File.exist?(@file_path)
      assert_equal steve_raw, File.read(@file_path)
    end

    def test_remove_the_snapshot_when_an_exception_is_raised
      stub(Time).now { @now }
      mock(Net::HTTP).get(URI.parse(Settings.steve_snapshotter.url)) { raise Errno::ENETUNREACH }

      Dritorjan::Jobs::SteveSnapshotter.new.perform

      refute File.exist?(@file_path)
    end
  end
end
