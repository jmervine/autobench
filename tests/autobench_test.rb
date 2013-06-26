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

end

# vim: ft=ruby:
