require "minitest/autorun"
require "autobench"

class TestAutobench < Minitest::Test

  def new_ab overides={}
    Autobench.new("./config/config.yml", overides)
  end

  def setup
    @phantomjs ||= File.expand_path(File.join(::Autobench::LIB_DIR, "..", "tests", "support", "phantomjs"))
    @node      ||= File.expand_path(File.join(::Autobench::LIB_DIR, "..", "tests", "support", "node"))
  end

  def test_init
    assert new_ab
    assert new_ab({ "server" => "localhost" })
  end

  def test_config
    ab = new_ab({ "server" => "localhost", "port" => 4567 })
    assert ab.config.is_a?(Autobench::Config),
      "config wasn't what was expected"
    assert_equal "localhost" , ab.config["server"]
    assert_equal 4567        , ab.config["port"]
    assert_equal "/"         , ab.config["uri"]
  end

  def test_render
    ab = new_ab({
      "server" => "localhost", "port" => 4567,
      "paths" => { "httperf" => File.join(File.dirname(__FILE__), "support/httperf") }})
    assert ab.render.benchmark,
      "benchmark should have been"
    assert ab.render.passed?,
      "render should have passed"
  end

  def test_yslow
    ab = new_ab({
      "server" => "localhost", "port" => 4567,
      "paths" => { "phantomjs" => @phantomjs}})

    assert ab.yslow.benchmark,
      "benchmark should have been"
    assert ab.yslow.passed?,
      "yslow should have passed"
  end

  def test_client
    ab = new_ab({
      "server" => "localhost", "port" => 4567,
      "paths" => { "node" => @node}})

    assert ab.client.benchmark,
      "benchmark should have been"
    assert ab.client.passed?,
      "client should have passed"
  end
end

# vim: ft=ruby:
