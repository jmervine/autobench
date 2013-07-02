require "minitest/autorun"
require "autobench"

class TestAutobenchYSlow < Minitest::Test

  def new_yslow overides={}, config="./config/config.yml"
    Autobench::YSlow.new(Autobench::Config.new(config, @options.merge(overides)))
  end

  def setup
    @rootdir   ||= File.expand_path("..", File.dirname(__FILE__))
    @yslowjs   ||= File.expand_path(File.join(@rootdir, "lib"))
    @phantomjs ||= File.expand_path(File.join(::Autobench::LIB_DIR, "..", "tests", "support", "phantomjs"))
    @options   ||= { "server" => "localhost", "paths" => { "phantomjs" => @phantomjs }}
    @yslow       = new_yslow
  end

  def test_initialize
    assert @yslow,
      "yslow should be"
    assert @yslow.instance_variable_get(:@config),
      "yslow should have config"

    min_yslow = new_yslow({}, "./config/min.yml")
    assert min_yslow.benchmark
  end

  def options
    assert_equal "", @yslow.send(:options)
    assert_equal "", new_yslow({"yslow" => {"foo" => "bar"}}).send(:options)
    assert_equal "--info all",
      new_yslow({"yslow" => {"info" => "all"}}).send(:options)
  end

  def test_command
    assert_equal "cd #{@yslowjs} && #{@phantomjs} ./yslow.js --info basic  'http://localhost/'",
      @yslow.send(:command)

    assert_equal "cd #{@yslowjs} && #{@phantomjs} ./yslow.js --info basic --ua foobar 'http://localhost/foobar'",
      new_yslow({"uri"   => "/foobar",
                 "yslow" => {
                   "ua"    => "foobar"}}
               ).send(:command)
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
