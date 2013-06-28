class Autobench
  class Client
    def initialize config
      @config       = config
      @full_results = []
    end

    def full_results
      raise "missing benchmarks" if @full_results.empty?
      @full_results
    end

    def benchmark
      @full_results = JSON.parse(%x{#{command}}.strip)
    end

    def passed?
      @config["thresholds"]["client"].each do |key,val|
        return false if fetch(key) > val
      end
      return true
    end

    def failed?
      !passed?
    end

    def [](key)
      return fetch(key)
    end

    def fetch(key)
      return median(full_results.map {|i| i[key] })
    end

    private
    def command
      "cd #{@config.phantomas} && #{@config.node} ./run-multiple.js #{modules} --url=#{@config["uri"]} --runs=#{@config["runs"]} --format=json"
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

