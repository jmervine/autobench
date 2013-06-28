require "minitest/autorun"
require "autobench"

class TestAutobench < Minitest::Test
  def setup
    @phantomjs ||= File.expand_path(File.join(::Autobench::LIB_DIR, "..", "tests", "support", "phantomjs"))
    @node      ||= File.expand_path(File.join(::Autobench::LIB_DIR, "..", "tests", "support", "node"))
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
    ab = Autobench.new("./config/config.yml", {
      "server" => "localhost", "port" => 4567,
      "paths" => { "httperf" => File.join(File.dirname(__FILE__), "support/httperf") }})
    assert ab.render.benchmark
    assert ab.render.passed?, "render should have passed"
  end

  def test_yslow
    ab = Autobench.new("./config/config.yml", {
      "server" => "localhost", "port" => 4567,
      "paths" => { "phantomjs" => @phantomjs}})

    assert ab.yslow.benchmark
    assert ab.yslow.passed?
  end

  def test_client
    ab = Autobench.new("./config/config.yml", {
      "server" => "localhost", "port" => 4567,
      "paths" => { "node" => @node}})

    assert ab.client.benchmark
    assert ab.client.passed?
  end
end

# vim: ft=ruby:
