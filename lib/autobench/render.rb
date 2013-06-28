require 'httperf'
class Autobench
  LIB_DIR ||= File.expand_path('..', File.dirname(__FILE__))
  class Render
    include Common
    def initialize config
      @config     = config
      @thresholds = config["thresholds"]["render"] rescue []
      @failures   = []
      @successes  = []
      setup_httperf_configuration(config)
    end

    def benchmark
      httperf       = HTTPerf.new(@httperf_config, @config.httperf)
      httperf.parse = true
      @full_results = httperf.run

      results = {}
      @thresholds.each do |key,threshold|
        results[key] = full_results[key.to_sym]
        if (full_results[key.to_sym].to_f > threshold.to_f)
          @failures.push("#{key} is #{full_results[key.to_sym].to_f}, threshold is #{threshold.to_f}")
        else
          @successes.push("#{key} is #{full_results[key.to_sym].to_f}, threshold is #{threshold.to_f}")
        end
      end
      return results
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
