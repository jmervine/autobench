require "yaml"
require "json"

class Autobench
  LIB_DIR ||= File.expand_path('..', File.dirname(__FILE__))
  class Config
    attr_accessor :basedir
    def initialize config, overides={}
      @config = if config.is_a?(String)
                  YAML.load_file(config).merge(overides)
                elsif config.is_a?(Hash)
                  config.merge(overides)
                else
                  raise "invalid config"
                end

      @config["port"] ||= 80
    end

    def phantomas
      default = File.join(::Autobench::LIB_DIR, "phantomas")
      begin
        return default if @config["paths"]["phantomas"].nil?
        return @config["paths"]["phantomas"]
      rescue NoMethodError
        return default
      end
    end

    def yslow
      default = ::Autobench::LIB_DIR
      begin
        return default if @config["paths"]["yslow"].nil?
        return @config["paths"]["yslow"]
      rescue NoMethodError
        return default
      end
    end

    %w{ httperf node phantomjs }.each do |bin|
      define_method(bin) do
        return @config["paths"][bin] rescue bin
      end
    end
    #def httperf
      #return @config["paths"]["httperf"] rescue "httperf"
    #end

    #def node
      #return @config["paths"]["node"] rescue "node"
    #end

    #def phantomjs
      #return @config["paths"]["phantomjs"] rescue "phantomjs"
    #end


    def method_missing(meth, *args, &block)
      @config.send(meth.to_sym, *args, &block) rescue super
    end
  end
end

# vim: ft=ruby:
