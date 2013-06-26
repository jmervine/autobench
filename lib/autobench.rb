require 'autobench/config'
require 'autobench/render'
require 'autobench/yslow'
require 'autobench/client'

class Autobench
  attr_accessor :config

  def initialize config, overides={}
    @config = Autobench::Config.new(config, overides)
  end
end

# vim: ft=ruby:
