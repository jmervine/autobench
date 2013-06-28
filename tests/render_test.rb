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
    @abrender   = Autobench::Render.new(Autobench::Config.new("./config/config.yml", @options))
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
    assert @abrender.passed?, "render should have passed"
    refute @abrender.failed?, "render should have failed"

    # make fail condition
    abrender = Autobench::Render.new(Autobench::Config.new("./config/config.yml", @options.merge(
      { "thresholds" => { "render" => { "connection_time_median" => 1 }}})))
    abrender.benchmark
    refute abrender.passed?, "render should not have passed"
    assert abrender.failed?, "render should have failed"
  end

  def test_failures
    abrender = Autobench::Render.new(Autobench::Config.new("./config/config.yml", @options.merge(
      { "thresholds" => { "render" => { "connection_time_median" => 1 }}})))
    abrender.benchmark
    assert abrender.failures.include?("[1] connection_time_median is 169.5, threshold is 1.0")

    @abrender.benchmark
    assert_equal "none", @abrender.failures
  end

  def test_successes
    @abrender.benchmark
    assert @abrender.successes.include?("[1] connection_time_median is 169.5, threshold is 200.0")

    abrender = Autobench::Render.new(Autobench::Config.new("./config/config.yml", @options.merge(
      { "thresholds" => { "render" => { "connection_time_median" => 1 }}})))
    abrender.benchmark
    assert_equal "none", abrender.successes
  end
end

# vim: ft=ruby:
