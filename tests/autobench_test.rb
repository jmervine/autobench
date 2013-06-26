require "minitest/autorun"
require "autobench"

class TestAutobench < Minitest::Test
  def setup
  end

  def teardown
  end

  def test_init
    assert Autobench.new("./config/config.yml")
    assert Autobench.new("./config/config.yml", { "server" => "localhost" })
  end

  def test_config
    ab = Autobench.new("./config/config.yml", { "server" => "localhost", "port" => 4567 })
    assert ab.config.is_a? Autobench::Config
    assert_equal "localhost" , ab.config["server"]
    assert_equal 4567        , ab.config["port"]
    assert_equal "/"         , ab.config["uri"]
  end

  def test_render
    ab = Autobench.new("./config/config.yml", { "server" => "localhost", "port" => 4567 })
    assert ab.render.benchmark
    assert ab.render.passed?
  end

  def test_yslow
    ab = Autobench.new("./config/config.yml", {
      "server" => "localhost", "port" => 4567,
      "phantomjs" => "./tests/support/phantomjs"})

    assert ab.yslow.benchmark
    assert ab.yslow.passed?
  end
end

# vim: ft=ruby:
