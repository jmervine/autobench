require 'json'
class Autobench
  LIB_DIR ||= File.expand_path('..', File.dirname(__FILE__))
  class YSlow
    def initialize config
      @config    = config
    end

    def full_results
      raise "missing benchmarks" unless @full_results
      @full_results
    end

    def benchmark
      @full_results = JSON.parse(%x{#{phantomjs_command}}.strip)
    end

    def passed?
      @config["thresholds"]["yslow"].each do |key,val|
        if key == "overall"
          return false if full_results[mappings[key]].to_i < val.to_i
        else
          return false if full_results[mappings[key]].to_i > val.to_i
        end
      end
      return true
    end

    def failed?
      !passed?
    end

    def [](key)
      return full_results[mappings[key]] if mappings.keys.include?(key)
      return full_results[key]           if mappings.values.include?(key)
      raise "unknown key"
    end

    private
    def yslow_command
      return "./yslow.js #{options} http://#{@config['server']}#{(@config.has_key?("port") ? ":#{@config['port']}" : "")}#{@config['uri']}"
    end

    def phantomjs_command
      "cd #{@config.yslow} && #{@config.phantomjs} #{yslow_command}"
    end

    def options
      return "" unless @config.has_key?("yslow")

      ret = []
      %w{ ruleset ua headers viewport }.each do |key|
        ret.push "--#{key} #{@config["yslow"][key]}" if @config["yslow"].has_key?(key)
      end

      return ret.join(" ")
    end

    def mappings
      {
        "overall"  => "o",
        "loadtime" => "lt",
        "requests" => "r",
        "size"     => "w"
      }
    end
  end
end

# vim: ft=ruby:
