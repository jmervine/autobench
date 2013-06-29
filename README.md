# autobench

[![Build Status](https://travis-ci.org/jmervine/autobench.png?branch=master)](https://travis-ci.org/jmervine/autobench)


Autobench, as follow up to [Autoperf](http://mervine.net/gems/autoperf), was created to allow for benchmarking web pages 
in three different ways. 

1. Render Metrics -- using [httperf](http://mervine.net/httperf] and [HTTPerf.rb](http://mervine.net/gems/httperfrb], it 
   grabs a snapshot of how long it takes to access, (server side) render and download your page. You can set thresholds 
   in your configuration for almost all of httperf's output. Additionally, if you use 
   [my version of httperf](http://mervine.net/httperf-0-9-1-with-individual-connection-times) you'll get percentile
   support as well.
2. Client Metrics -- using [`phantomas`](https://github.com/macbre/phantomas), a sweet [PhantomJS](http://mervine.net/phantomjs)
   script that grabs all kinds of useful DOM information from loading your page. See `phantomas` for more details.
3. YSlow Metrics -- using [`yslow.js`](http://yslow.org/phantomjs), a [PhantomJS](http://mervine.net/phantomjs) script
   written to inspect your page and give you all kinds of useful grading and information. See [YSlow](http://yslow.org)
   for more details.


## Installation

    gem install autobench --pre

    # or...

    bundle init
    echo "gem 'autobench', '0.0.1alpha1'" >> Gemfile
    bundle install --path vendor/bundle

## Usage

### With [Minitest](https://github.com/seattlerb/minitest)

    :::ruby
    require "minitest/autorun"
    require "autobench"

    class TestBenchmarks < Minitest::Test
        def setup
            @autobench = Autobench.new("./config/mervine.yml")
        end

        def test_autobench_render
            @autobench.render.benchmark
            assert @autobench.render.passed?,
                "Passed:\n#{@autobench.render.successes}\nFailed:\n#{@autobench.render.failures}"

        end

        def test_autobench_client
            @autobench.client.benchmark
            assert @autobench.client.passed?,
                "Passed:\n#{@autobench.client.successes}\nFailed:\n#{@autobench.client.failures}"
        end

        def test_autobench_yslow
            @autobench.yslow.benchmark
            assert @autobench.yslow.passed?,
                "Passed:\n#{@autobench.yslow.successes}\nFailed:\n#{@autobench.yslow.failures}"
        end
    end

    See [github.com/jmervine/autobench/examples](http://github.com/jmervine/autobench/examples)

### CLI

#### `autobench`

    Usage: autobench [options]

    Required Arguments:
        -c, --config FILENAME            configuration file

    Optional Arguments:

      Note: server, port, uri and runs overide what's in
      your configuation file.

        -s, --server SERVER              target server
        -p, --port PORT                  target port
        -u, --uri URI                    target uri
        -i, --runs RUNS                  itterations against target
        -f, --format [json|yaml|csv]     raw output format
        -r, --results [dirname]          results directory (default: /tmp)

    Module Exclusion:
        -R, --without-render             Do not include render (httperf).
        -Y, --without-yslow              Do not include yslow (yslow.js).
        -C, --without-client             Do not include client (phantomas).

    Misc. Arguments:
        -q, --quiet                      Print no things.
        -h, --help                       Show this message

#### `autobench-config`

The purpose of this is to generate a base configuration for your page, containing
all possible values in their current state.

> Note: I recommend looking over each configuration and removing those you don't
> care about. Also, you should bump most up just a bit to account for standard
> network variance.

    Usage: autobench-config [options]

    Required Arguments:
        -o, --output FILENAME            configuration output file

    Optional Arguments:

      Note: server, port, uri and runs overide defaults:
      - server: 'localhost'
      - port:   80
      - uri:    '/'
      - runs:   9

        -s, --server SERVER              target server
        -p, --port PORT                  target port
        -u, --uri URI                    target uri
        -i, --runs RUNS                  itterations against target

    Module Exclusion:
        -R, --without-render             Do not include render (httperf).
        -Y, --without-yslow              Do not include yslow (yslow.js).
        -C, --without-client             Do not include client (phantomas).

    Misc. Arguments:
        -h, --help                       Show this message

