require 'autobench/config'
require 'autobench/render'
require 'autobench/yslow'
require 'autobench/loadreport'

class Autobench
  attr_accessor :config

  BENCH_DIR ||= File.dirname(__FILE__)

  def initialize config, overides={}
    @config = Autobench::Config.new(config, overides)
  end

  def render
    @render ||= Autobench::Render.new(@config)
  end

  def yslow
    @yslow  ||= Autobench::YSlow.new(@config)
  end

  def loadreport
    @loadreport ||= "unimplemented"
  end
end

# vim: ft=ruby:
