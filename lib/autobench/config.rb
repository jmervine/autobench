require "yaml"
class Autobench
  class Config
    def initialize config, overides={}
      @config = YAML.load_file(config).merge(overides)
    end

    def method_missing(meth, *args, &block)
      @config.send(meth.to_sym, *args, &block) rescue super
    end
  end
end

# vim: ft=ruby:
