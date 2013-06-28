class Autobench
  class Client
    include Common
    def initialize config
      @config       = config
      @full_results = []
      @failures     = []
      @successes    = []
    end

    def benchmark
      begin
        @full_results = JSON.parse(%x{#{command}}.strip)
        @config["thresholds"]["client"].each do |key,threshold|
          if fetch(key) > threshold
            @failures.push("#{key} is #{fetch(key)}, threshold is #{threshold}")
          else
            @successes.push("#{key} is #{fetch(key)}, threshold is #{threshold}")
          end
        end
        @full_results
      rescue
        puts "COMMAND FAILED: #{command}"
        raise
      end
    end

    def [](key)
      return fetch(key)
    end

    def fetch(key)
      return median(full_results.map {|i| i[key] })
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

