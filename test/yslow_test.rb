require "minitest/autorun"
require "autobench"

class TestAutobenchYSlow < Minitest::Test
  def setup
    @phantomjs ||= File.expand_path(File.join(::Autobench::LIB_DIR, "..", "test", "support", "phantomjs"))
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
    assert_equal Hash, Autobench::YSlow.new(Autobench::Config.new("./config/config.yml",
                 { "paths" => {"phantomjs" => @phantomjs}})).benchmark.class
  end

  def test_passed?
    abyslow = Autobench::YSlow.new(Autobench::Config.new("./config/config.yml",
                 {"server" => "localhost",
                  "paths"  => { "phantomjs" => @phantomjs }}))
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
