require "minitest/autorun"
require "autobench"

class TestAutobenchConfig < Minitest::Test
  def new_config overide={}, config="./config/config.yml"
    Autobench::Config.new(config, overide)
  end

  def test_init
    assert new_config
    assert new_config({ "server" => "localhost", "uri" => "/"})
    assert new_config({ "server" => "localhost", "uri" => "/"}).instance_variable_get(:@config)

    assert_equal 80, new_config({"server"=>"localhost", "uri"=>"/"}).instance_variable_get(:@config)["port"]
  end

  def test_config
    ab = new_config
    assert_equal "mervine.net" , ab["server"]
    assert_equal "/"           , ab["uri"]
    assert_equal 9             , ab["runs"]
  end

  def test_overides
    ab = new_config({ "server" => "localhost", "uri" => "/foo"})
    assert_equal "localhost" , ab["server"]
    assert_equal "/foo"      , ab["uri"]
  end

  #def test_uri_quoting
    #ab = new_config({"uri" => "/foo/bar?foo=bar&bar=foo"})
    #assert_equal "'/foo/bar?foo=bar&bar=foo'", ab["uri"]
    #ab = new_config({"uri" => "'/foo/bar?foo=bar&bar=foo'"})
    #assert_equal "'/foo/bar?foo=bar&bar=foo'", ab["uri"]
    #ab = new_config({"uri" => '"/foo/bar?foo=bar&bar=foo"'})
    #assert_equal '"/foo/bar?foo=bar&bar=foo"', ab["uri"]
  #end
end

# vim: ft=ruby:

