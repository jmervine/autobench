require 'json'
class Autobench
  LIB_DIR ||= File.expand_path('..', File.dirname(__FILE__))
  class YSlow
    include Common
    def initialize config
      @config     = config
      @thresholds = config["thresholds"]["yslow"] rescue []
      @failures   = []
      @successes  = []
    end

    def benchmark
      begin
        @full_results = JSON.parse(%x{#{command}}.strip)
      rescue
        raise "Error running: #{command}"
      end
      @thresholds.each do |key,threshold|
        # U-G-L-Y
        if key == "overall"
          if full_results[mappings[key]].to_i < threshold.to_i
            @failures.push("#{key} is #{full_results[mappings[key]]}, threshold is #{threshold}");
          else
            @successes.push("#{key} is #{full_results[mappings[key]]}, threshold is #{threshold}");
          end
        else
          if full_results[mappings[key]].to_i > threshold.to_i
            @failures.push("#{key} is #{full_results[mappings[key]]}, threshold is #{threshold}");
          else
            @successes.push("#{key} is #{full_results[mappings[key]]}, threshold is #{threshold}");
          end
        end
      end
      @full_results
    end

    def [](key)
      return full_results[mappings[key]] if mappings.keys.include?(key)
      return full_results[key]           if mappings.values.include?(key)
      return nil
    end

    def full_results
      return clean_keys(@full_results, ['u','i'])
    end

    def mappings
      {
        "overall"  => "o",
        "loadtime" => "lt",
        "requests" => "r",
        "size"     => "w"
      }
    end

    private
    def command
      "cd #{@config.yslow} && #{@config.phantomjs} ./yslow.js --info basic #{options} http://#{@config['server']}#{(@config.has_key?("port") ? ":#{@config['port']}" : "")}#{@config['uri']}"
    end

    def options
      return "" unless @config.has_key?("yslow")

      ret = []
      %w{ ruleset ua headers viewport }.each do |key|
        ret.push "--#{key} #{@config["yslow"][key]}" if @config["yslow"].has_key?(key)
      end

      return ret.join(" ")
    end
  end
end

# vim: ft=ruby:
