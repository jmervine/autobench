require "minitest/autorun"
require "autobench"

class TestAutobenchYSlow < Minitest::Test
  def setup
    @phantomjs ||= File.expand_path(File.join(::Autobench::LIB_DIR, "..", "tests", "support", "phantomjs"))
    @options   ||= { "server" => "localhost", "paths" => { "phantomjs" => @phantomjs }}
    @abyslow ||= Autobench::YSlow.new(Autobench::Config.new("./config/config.yml", @options))
  end

  def test_initialize
    assert @abyslow
    assert @abyslow.instance_variable_get(:@config)
  end

  def options
    assert_equal "",
      @abyslow.send(:options)

    assert_equal "",
      Autobench::YSlow.new(Autobench::Config.new("./config/config.yml",
                                                 {"yslow" => {"foo" => "bar"}}
                                                )).send(:options)

    assert_equal "--info all",
      Autobench::YSlow.new(Autobench::Config.new("./config/config.yml",
                                                 {"yslow" => {"info" => "all"}}
                                                )).send(:options)
  end

  def yslow_command
    assert_equal "./lib/yslow.js  http://localhost:80/",
      @abyslow.send(:yslow_command)

    assert_equal "./lib/yslow.js --info all --ua foobar http://localhost:80/foobar",
      Autobench::YSlow.new(Autobench::Config.new("./config/config.yml",
                                                 @options.merge({"uri"   => "/foobar",
                                                  "yslow" => {
                                                    "info"  => "all",
                                                    "ua"    => "foobar"}})
                                                )).send(:yslow_command)
  end

  def test_benchmark
    assert_equal Hash, Autobench::YSlow.new(Autobench::Config.new("./config/config.yml", @options)).benchmark.class
  end

  def test_passed?
    abyslow = Autobench::YSlow.new(Autobench::Config.new("./config/config.yml", @options))
    abyslow.benchmark

    assert abyslow.passed?, "should have passed"
    refute abyslow.failed?, "should have not failed"

    # make fail condition
    abyslow = Autobench::YSlow.new(Autobench::Config.new("./config/config.yml",
                   @options.merge({"thresholds" => { "yslow" => { "overall" => 100}}})))
    abyslow.benchmark

    refute abyslow.passed?, "should have not passed"
    assert abyslow.failed?, "should have failed"
  end

  def test_failures
    abyslow = Autobench::YSlow.new(Autobench::Config.new("./config/config.yml",
                                                         @options.merge({ "thresholds" => { "yslow" => { "overall" => 100}}})))
    abyslow.benchmark
    assert abyslow.failures.include?("[1] overall is 64, threshold is 100"),
      "didn't expect `#{abyslow.failures}`"

    @abyslow.benchmark
    assert_equal "none", @abyslow.failures
  end

  def test_successes
    @abyslow.benchmark
    assert @abyslow.successes.include?("[1] overall is 64, threshold is 60"),
      "didn't expect `#{@abyslow.successes}`"

    abyslow = Autobench::YSlow.new(Autobench::Config.new("./config/config.yml",
                                                         @options.merge({ "thresholds" => { "yslow" => { "overall" => 100}}})))
    abyslow.benchmark
    assert_equal "none", abyslow.successes
  end
end

# vim: ft=ruby:
