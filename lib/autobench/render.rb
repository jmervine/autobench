require 'httperf'
class Autobench
  LIB_DIR ||= File.expand_path('..', File.dirname(__FILE__))
  class Render
    include Common
    def initialize config
      @config     = config
      @thresholds = config["thresholds"]["render"] rescue []
      @thresholds = [] if @thresholds.nil?
      @failures   = []
      @successes  = []
      setup_httperf_configuration(config)
    end

    def benchmark
      httperf       = HTTPerf.new(@httperf_config, @config.httperf)
      httperf.parse = true

      @full_results = httperf.run.inject({}){|memo,(k,v)| memo[k.to_s] = v; memo}
                                  # keys: sym -> str

      @thresholds.each do |key,threshold|
        if higher_is_better.include?(key)
          if (full_results[key].to_f < threshold.to_f)
            @failures.push("#{key} is #{full_results[key].to_f}, threshold is #{threshold.to_f}")
          else
            @successes.push("#{key} is #{full_results[key].to_f}, threshold is #{threshold.to_f}")
          end
        else
          if (full_results[key].to_f > threshold.to_f)
            @failures.push("#{key} is #{full_results[key].to_f}, threshold is #{threshold.to_f}")
          else
            @successes.push("#{key} is #{full_results[key].to_f}, threshold is #{threshold.to_f}")
          end
        end
      end

      ignored_keys.each do |key|
        @full_results.delete(key)
      end

      @full_results
    end

    def [](key)
      full_results[key].to_f
    end

    def full_results
      return clean_keys(@full_results, %w[ command connection_times net_io_bps ])
    end

    private
    def setup_httperf_configuration config
      @httperf_config = {} # defaults

      if config.has_key?("httperf")
        puts config["httperf"]
        @httperf_config.merge!(config["httperf"])
      end

      # all required
      %w{ server uri }.each do |key|
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

    def higher_is_better
      %w[
        connection_rate_per_sec
        request_rate_per_sec
        reply_status_2xx
        total_connections
        total_requests
        total_replies
      ]
    end
    def ignored_keys
      %w[
        max_connect_burst_length
        cpu_time_system_pct
        cpu_time_total_pct
        cpu_time_user_sec
        cpu_time_system_sec
        cpu_time_user_pct
        reply_rate_min
        reply_rate_avg
        reply_rate_max
        reply_rate_stddev
        reply_rate_samples
        connection_length
      ]
    end
  end
end
# vim: ft=ruby:
