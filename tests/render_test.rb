require "minitest/autorun"
require "autobench"

## Mock Httperf#run to parse static results
class HTTPerf
  def run
    $verbose_raw ||= File.open("./tests/support/dummy_verbose_results.txt","r").read
    return Parser.parse($verbose_raw)
  end
end

class TestAutobenchRender < Minitest::Test
  def setup
    @options  ||= { "paths" => { "httperf" => File.join(File.dirname(__FILE__), "support/httperf") }}
    @abrender ||= Autobench::Render.new(Autobench::Config.new("./config/config.yml", @options))
  end

  def test_initialize
    assert Autobench::Render.new(Autobench::Config.new("./config/config.yml", @options))
    assert Autobench::Render.new(Autobench::Config.new("./config/config.yml", @options)).instance_variable_get(:@httperf_config)
    assert Autobench::Render.new(Autobench::Config.new("./config/config.yml", @options)).instance_variable_get(:@thresholds)
  end

  def test_benchmark
    results = @abrender.benchmark
    assert_equal "169.5", results["connection_time_median"]
  end

  def test_passed?
    @abrender.benchmark
    assert @abrender.passed?
    refute @abrender.failed?

    # make fail condition
    @abrender.instance_variable_get(:@thresholds)["connection_time_99_pct"] = 1
    refute @abrender.passed?
    assert @abrender.failed?
  end
end

# vim: ft=ruby:
