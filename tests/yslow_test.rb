require "minitest/autorun"
require "autobench"

class TestAutobenchYSlow < Minitest::Test
  def setup
    @abyslow ||= Autobench::YSlow.new(Autobench::Config.new("./config/config.yml"))
  end

  def teardown
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
                                                 {"uri"   => "/foobar",
                                                  "yslow" => {
                                                    "info"  => "all",
                                                    "ua"    => "foobar"}}
                                                )).send(:yslow_command)
  end

  def test_benchmark
    results = Autobench::YSlow.new(Autobench::Config.new("./config/config.yml",
                 { "phantomjs" => "./tests/support/phantomjs"})).benchmark
    assert_equal 64, results["o"]
  end

  def test_passed?
    abyslow = Autobench::YSlow.new(Autobench::Config.new("./config/config.yml",
                 {"server"    => "localhost",
                  "phantomjs" => "./tests/support/phantomjs"}))
    abyslow.benchmark

    assert abyslow.passed?
    refute abyslow.failed?

    # make fail condition
    abyslow.instance_variable_get(:@config)["thresholds"]["yslow"]["overall"] = 70
    refute abyslow.passed?
    assert abyslow.failed?
  end
end

# vim: ft=ruby:
