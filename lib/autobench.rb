require 'autobench/config'
require 'autobench/render'
require 'autobench/yslow'
require 'autobench/client'

class Autobench
  attr_accessor :config

  LIB_DIR ||= File.dirname(__FILE__)

  def initialize config, overides={}
    @config = Autobench::Config.new(config, overides)
  end

  def render
    @render ||= Autobench::Render.new(@config)
  end

  def yslow
    @yslow  ||= Autobench::YSlow.new(@config)
  end

  def client
    @client ||= Autobench::Client.new(@config)
  end
end

# vim: ft=ruby:
