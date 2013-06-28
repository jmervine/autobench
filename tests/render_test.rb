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

  def new_render overides={}
    Autobench::Render.new( Autobench::Config.new( "./config/config.yml", @options.merge(overides)))
  end

  def setup
    @options  ||= { "paths" => { "httperf" => File.join(File.dirname(__FILE__), "support/httperf") }}
    @render = new_render
  end

  def test_initialize
    assert @render, "render should be"
    assert @render.instance_variable_get(:@httperf_config),
      "render should have httperf_config"
    assert @render.instance_variable_get(:@thresholds),
      "render should have thresholds"
  end

  def test_benchmark
    assert_equal "169.5", @render.benchmark["connection_time_median"]
  end

  def test_passed?
    @render.benchmark
    assert @render.passed?, "render should have passed"
    refute @render.failed?, "render should have failed"

    # make fail condition
    render = new_render({ "thresholds" => { "render" => { "connection_time_median" => 1 }}})
    render.benchmark
    refute render.passed?, "render should not have passed"
    assert render.failed?, "render should have failed"
  end

  def test_failures
    render = new_render({ "thresholds" => { "render" => { "connection_time_median" => 1 }}})
    render.benchmark
    assert render.failures.include?("[1] connection_time_median is 169.5, threshold is 1.0"),
      "failures didn't have what was expected"

    @render.benchmark
    assert_equal "none", @render.failures
  end

  def test_successes
    @render.benchmark
    assert @render.successes.include?("[1] connection_time_median is 169.5, threshold is 200.0"),
      "successes didn't have what was expected"

    render = new_render({ "thresholds" => { "render" => { "connection_time_median" => 1 }}})
    render.benchmark
    assert_equal "none", render.successes
  end
end

# vim: ft=ruby:
