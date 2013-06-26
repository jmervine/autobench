require 'httperf'
class Autobench::Render
  attr_accessor :full_results

  def initialize config
    @httperf        = config.delete("httperf") || nil
    @config         = config
    @httperf_config = httperf_config

    @httperf_config["server"] = config["server"] if config.has_key?("server")
    @httperf_config["port"]   = config["port"]   if config.has_key?("port")
    @httperf_config["uri"]    = config["uri"]    if config.has_key?("uri")

    @httperf_config.merge!(config["render"])     if config.has_key?("render")
  end

  def benchmark
    httperf       = HTTPerf.new(@httperf_config, @httperf)
    httperf.parse = true
    @full_results = httperf.run

    results = {}
    @config["thresholds"]["render"].each_key do |key|
      results[key] = full_results[key.to_sym]
    end
    return results
  end

  def [](key)
    raise "missing benchmarks" unless @full_results
    @full_results[key.to_sym]
  end

  def passed?
    raise "missing benchmarks" unless @full_results
    @config["thresholds"]["render"].each do |key,val|
      return false if (full_results[key.to_sym].to_f > val.to_f)
    end
    return true
  end

  def failed?
    !passed?
  end

  private
  def httperf_config
    { "server"    => "localhost",
      "uri"       => "/",
      "port"      => 80,
      "num-conns" => 9,
      "verbose"   => true }
  end
end

# vim: ft=ruby:
