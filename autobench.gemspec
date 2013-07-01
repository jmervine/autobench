# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'autobench/version'

Gem::Specification.new do |s|
  s.name        = "autobench"
  s.version     = Autobench::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Joshua Mervine"]
  s.email       = ["joshua@mervine.net"]
  s.homepage    = "http://mervine.net/gems/autobench"
  s.summary     = "Autobench (w/ httperf, yslow.js, phantomas)"
  s.description = "Autobench is a ruby based web page benchmarking tool, wrapping other popular utiliies. Namely: httperf, yslow.js and phantomas."

  s.add_development_dependency "rake", "~> 10.1.0"
  s.add_development_dependency "minitest", "~> 5.0.5"

  s.add_dependency "httperfrb", "~> 0.3.11"

  s.files        = Dir.glob("lib/**/*") + Dir.glob("bin/**/*") + %w(README.md)
  s.require_path = 'lib'
  s.bindir       = 'bin'
  s.executables << 'autobench'
  s.executables << 'autobench-config'
end

# vim: filetype=ruby:
