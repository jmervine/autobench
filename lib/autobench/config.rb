require "yaml"
require "json"

class Autobench
  class Config
    def initialize config, overides={}
      @config = YAML.load_file(config).merge(overides)

      generate_loadreport_json
    end

    def method_missing(meth, *args, &block)
      @config.send(meth.to_sym, *args, &block) rescue super
    end

    def loadreport_json
      @loadreport_json ||= File.join(Autobench::BENCH_DIR, "config.json")
    end

    private
    def generate_loadreport_json
      File.open(loadreport_json, "w") do |file|
        file.write(@config["client"].to_json)
      end
    end
  end
end

# vim: ft=ruby:
