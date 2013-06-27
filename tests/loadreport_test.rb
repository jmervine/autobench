require "minitest/autorun"
require "autobench"

class TestAutobenchLoadreport < Minitest::Test
  def setup
    @options ||= {}
  end

  def teardown
  end

  def test_initialize
    assert Autobench::Loadreport.new(Autobench::Config.new("./config/config.yml", @options))
    assert Autobench::Loadreport.new(Autobench::Config.new("./config/config.yml", @options)).instance_variable_get(:@config)
  end
end

# vim: ft=ruby:

