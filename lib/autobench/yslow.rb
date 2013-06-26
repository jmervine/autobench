require 'json'
class Autobench::YSlow
  attr_accessor :yslow, :phantomjs, :full_results

  def initialize config
    @yslow     = config.delete("yslow_js")  || "./lib/yslow.js"
    @phantomjs = config.delete("phantomjs") || "phantomjs"
    @config    = config
  end

  def benchmark
    @full_results = JSON.parse(%x{#{phantomjs_command}}.strip)
  end

  def passed?
    raise "missing benchmarks" unless @full_results
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
    raise "missing benchmarks"         unless @full_results

    return full_results[mappings[key]] if mappings.keys.include?(key)
    return full_results[key]           if mappings.values.include?(key)

    raise "unknown key"
  end

  private
  def yslow_command
    return "#{yslow} #{options} http://#{@config['server']}#{(@config.has_key?("port") ? ":#{@config['port']}" : "")}#{@config['uri']}"
  end

  def phantomjs_command
    "#{phantomjs} #{yslow_command}"
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

# vim: ft=ruby:
