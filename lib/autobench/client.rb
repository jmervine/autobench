class Autobench
  class Client
    include Common
    def initialize config
      @config       = config
      @thresholds   = @config["thresholds"]["client"] rescue []
      @thresholds   = [] if @thresholds.nil?
      @full_results = []
      @failures     = []
      @successes    = []
    end

    def benchmark
      begin
        @full_results = JSON.parse(%x{#{command}}.strip)
        @thresholds.each do |key,threshold|
          if fetch(key) > threshold
            @failures.push("#{key} is #{fetch(key)}, threshold is #{threshold}")
          else
            @successes.push("#{key} is #{fetch(key)}, threshold is #{threshold}")
          end
        end
        @full_results
      rescue
        raise "COMMAND FAILED: #{command}"
      end
    end

    def [](key)
      return fetch(key)
    end

    def fetch(key)
      return median(raw_results.map {|i| i[key] })
    end

    # backdoor hook to @full_results
    def raw_results
      raise "missing benchmarks" unless @full_results
      @full_results
    end

    # generate result set that is only medians by default
    def full_results
      r = {}
      raw_results.first.keys.each do |key|
        r[key] = fetch(key)
      end
      return r
    end

    private
    def command
      "cd #{@config.phantomas} && #{@config.node} ./run-multiple.js #{modules} --url=#{url} --runs=#{@config["runs"]} --format=json"
    end

    def url
      "http://#{@config['server']}#{(@config['port'] == 80 ? "" : ":#{@config['port']}")}#{@config['uri']}"
    end

    def modules
      mod_str = ""
      if @config.has_key?("phantomas") && @config["phantomas"].has_key?("modules")
        mod_str << "--modules="+@config["phantomas"]["modules"].join(",")
      end
      return mod_str
    end

    def median(array)
      sorted = array.sort
      len = sorted.length
      return (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
    end
  end
end

# vim: ft=ruby:

