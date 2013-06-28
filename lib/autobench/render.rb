require 'httperf'
class Autobench
  LIB_DIR ||= File.expand_path('..', File.dirname(__FILE__))
  class Render
    attr_accessor :full_results

    def initialize config
      @config     = config
      @thresholds = config.delete("thresholds")["render"]
      setup_httperf_configuration(config)
    end

    def benchmark
      httperf       = HTTPerf.new(@httperf_config, @config.httperf)
      httperf.parse = true
      @full_results = httperf.run

      results = {}
      @thresholds.each_key do |key|
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
      @thresholds.each do |key,val|
        return false if (full_results[key.to_sym].to_f > val.to_f)
      end
      return true
    end

    def failed?
      !passed?
    end

    private
    def setup_httperf_configuration config
      @httperf_config = {} # defaults

      if config.has_key?("httperf")
        puts config["httperf"]
        @httperf_config.merge!(config["httperf"])
      end

      # all required
      %w{ server port uri }.each do |key|
        raise "Autobench::Render missing `#{key}`." unless config.has_key?(key)
        @httperf_config[key] = config[key]
      end

      if config.has_key?("runs")
        @httperf_config["num-conns"] = config["runs"]
      end

      @httperf_config.merge!(httperf_forced_options)
    end

    def httperf_forced_options
      { "verbose"   => true }
    end
  end
end
# vim: ft=ruby:
