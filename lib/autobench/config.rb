require "yaml"
require "json"

class Autobench
  LIB_DIR ||= File.expand_path('..', File.dirname(__FILE__))
  class Config
    attr_accessor :basedir
    def initialize config, overides={}
      @config = YAML.load_file(config).merge(overides)
    end

    def phantomas
      return @config["paths"]["phantomas"] rescue File.join(::Autobench::LIB_DIR, "phantomas")
    end

    def yslow
      return @config["paths"]["yslow"] rescue ::Autobench::LIB_DIR
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
