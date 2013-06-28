require "minitest/autorun"
require "autobench"

class TestAutobenchClient < Minitest::Test
  def setup
    @rootdir ||= File.expand_path("..", File.dirname(__FILE__))
    @options ||= { "paths" => { "node" => File.expand_path(File.join(::Autobench::LIB_DIR, "..", "tests", "support", "node")) }}
    @client    = Autobench::Client.new(Autobench::Config.new("./config/config.yml", @options))
  end

  def test_initialize
    assert @client
    assert @client.instance_variable_get(:@config)
  end

  def test_modules
    assert_equal "--modules=ajaxRequests,assetsTypes,cacheHits,caching,cookies,domComplexity,domQueries,domains,globalVariables,headers,localStorage,requestsStats,staticAssets,waterfall,windowPerformance",
      @client.send(:modules)

    modules = { "phantomas" => { "modules" => [ "foobar", "bahboo", "bing" ]}}
    assert_equal "--modules=foobar,bahboo,bing",
      Autobench::Client.new(Autobench::Config.new("./config/config.yml", @options.merge(modules))).send(:modules)
  end

  def test_command
    options = @options.merge({ "phantomas" => { "modules" => [ "foobar", "bahboo", "bing" ]}})
    options.delete("paths") # don't want this for this test

    assert_equal "cd #{@rootdir}/lib/phantomas && node ./run-multiple.js --modules=foobar,bahboo,bing --url=/ --runs=9 --format=json",
      Autobench::Client.new(Autobench::Config.new("./config/config.yml", options)).send(:command)

    options = options.merge("uri" => "/foobar", "runs" => 5)
    assert_equal "cd #{@rootdir}/lib/phantomas && node ./run-multiple.js --modules=foobar,bahboo,bing --url=/foobar --runs=5 --format=json",
      Autobench::Client.new(Autobench::Config.new("./config/config.yml", options)).send(:command)
  end

  def test_benchmark
    assert_equal Array, @client.benchmark.class
  end

  def test_passed?
    @client.benchmark
    assert @client.passed?
    refute @client.failed?

    # these mess up the median force a fail
    @client.instance_variable_get(:@full_results).first["requests"] = 1000
    @client.instance_variable_get(:@full_results).last["requests"]  = 1000

    refute @client.passed?
    assert @client.failed?
  end
end

# vim: ft=ruby:
