require "minitest/autorun"
require "autobench"

class TestAutobenchYSlow < Minitest::Test

  def new_yslow overides={}
    Autobench::YSlow.new(Autobench::Config.new("./config/config.yml", @options.merge(overides)))
  end

  def setup
    @phantomjs ||= File.expand_path(File.join(::Autobench::LIB_DIR, "..", "tests", "support", "phantomjs"))
    @options   ||= { "server" => "localhost", "paths" => { "phantomjs" => @phantomjs }}
    @yslow       = new_yslow
  end

  def test_initialize
    assert @yslow,
      "yslow should be"
    assert @yslow.instance_variable_get(:@config),
      "yslow should have config"
  end

  def options
    assert_equal "", @yslow.send(:options)
    assert_equal "", new_yslow({"yslow" => {"foo" => "bar"}}).send(:options)
    assert_equal "--info all",
      new_yslow({"yslow" => {"info" => "all"}}).send(:options)
  end

  def yslow_command
    assert_equal "./lib/yslow.js  http://localhost:80/",
      @yslow.send(:yslow_command)

    assert_equal "./lib/yslow.js --info all --ua foobar http://localhost:80/foobar",
      new_yslow({"uri"   => "/foobar",
                 "yslow" => {
                   "info"  => "all",
                   "ua"    => "foobar"}}
               ).send(:yslow_command)
  end

  def test_benchmark
    assert_equal Hash, new_yslow.benchmark.class
  end

  def test_passed?
    @yslow.benchmark

    assert @yslow.passed?, "should have passed"
    refute @yslow.failed?, "should have not failed"

    # make fail condition
    yslow = new_yslow({"thresholds" => { "yslow" => { "overall" => 100}}})
    yslow.benchmark

    refute yslow.passed?, "should have not passed"
    assert yslow.failed?, "should have failed"
  end

  def test_failures
    yslow = new_yslow({ "thresholds" => { "yslow" => { "overall" => 100}}})
    yslow.benchmark

    assert yslow.failures.include?("[1] overall is 64, threshold is 100"),
      "expected something different"

    @yslow.benchmark
    assert_equal "none", @yslow.failures
  end

  def test_successes
    @yslow.benchmark
    assert @yslow.successes.include?("[1] overall is 64, threshold is 60"),
      "expected something different"

    yslow = new_yslow({ "thresholds" => { "yslow" => { "overall" => 100}}})
    yslow.benchmark

    assert_equal "none", yslow.successes
  end
end

# vim: ft=ruby:
