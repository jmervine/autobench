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

    assert_equal "cd #{@rootdir}/lib/phantomas && node ./run-multiple.js --modules=foobar,bahboo,bing --url=http://mervine.net/ --runs=9 --format=json",
      Autobench::Client.new(Autobench::Config.new("./config/config.yml", options)).send(:command)

    options = options.merge("uri" => "/foobar", "port" => 8080, "runs" => 5)
    assert_equal "cd #{@rootdir}/lib/phantomas && node ./run-multiple.js --modules=foobar,bahboo,bing --url=http://mervine.net:8080/foobar --runs=5 --format=json",
      Autobench::Client.new(Autobench::Config.new("./config/config.yml", options)).send(:command)
  end

  def test_benchmark
    assert_equal Array, @client.benchmark.class
  end

  def test_passed?
    @client.benchmark
    assert @client.passed?, "client should pass"
    refute @client.failed?, "client should not fail"

    client = Autobench::Client.new(Autobench::Config.new("./config/config.yml", @options.merge({ "thresholds" => { "client" => { "requests" => 1 }}})))
    client.benchmark
    refute client.passed?, "client should not pass"
    assert client.failed?, "client should fail"
  end

  def test_failures
    client = Autobench::Client.new(Autobench::Config.new("./config/config.yml", @options.merge({ "thresholds" => { "client" => { "requests" => 1 }}})))
    client.benchmark
    assert client.failures.include?("[1] requests is 145.0, threshold is 1"),
      "didn't expect `#{client.failures}`"

    @client.benchmark
    assert_equal "none", @client.failures
  end

  def test_successes
    @client.benchmark
    assert @client.successes.include?("[1] requests is 145.0, threshold is 145.0"),
      "didn't expect `#{@client.successes}`"

    client = Autobench::Client.new(Autobench::Config.new("./config/config.yml", @options.merge({ "thresholds" => { "client" => { "requests" => 1 }}})))
    client.benchmark
    assert_equal "none", client.successes
  end
end

# vim: ft=ruby:
