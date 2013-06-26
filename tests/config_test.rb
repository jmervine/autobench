require "minitest/autorun"
require "autobench"

class TestAutobenchConfig < Minitest::Test
  def test_init
    assert Autobench::Config.new("./config/config.yml")
    assert Autobench::Config.new("./config/config.yml", { "server" => "localhost", "uri" => "/"})
    assert Autobench::Config.new("./config/config.yml", { "server" => "localhost", "uri" => "/"}).instance_variable_get(:@config)
  end

  def test_config
    ab = Autobench::Config.new("./config/config.yml")
    assert_equal "mervine.net" , ab["server"]
    assert_equal "/"           , ab["uri"]
    assert_equal 9             , ab["render"]["num-conns"]
  end

  def test_overides
    ab = Autobench::Config.new("./config/config.yml", { "server" => "localhost", "uri" => "/foo"})
    assert_equal "localhost" , ab["server"]
    assert_equal "/foo"      , ab["uri"]
  end
end

# vim: ft=ruby:

