# autobench

> NOTE: This is still very much under development and I've written the README to define how I plan for it to work.
>
> TODOs:
>
> * Functional tests - without httperf, node, phantomjs stubs.
> * Creating `autobench` binary.
> * Build and release gem.

### TODO: Installation

    gem install autobench

    # or...

    bundle init
    echo "gem 'autobench'" >> Gemfile
    bundle install --path vendor/bundle

### Usage

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

### Minitest Integration

> #### TODO
> Advanced Examples

    require "minitest/autorun"
    require "autobench"

    class TestBenchmarks < Minitest::Test
        def setup
            @autobench = Autobench.new( "./path/to/config.yml", { ... config overides ... } )
        end

        def test_autobench_render
            @autobench.render.benchmark
            assert @autobench.render["connection_time_median"] < 500 # ms

            # or...
            assert @autobench.render.passed?
        end

        def test_autobench_yslow
            @autobench.yslow.benchmark
            assert @autobench.yslow["overall"] >= 95 # score

            # or...
            assert @autobench.yslow.passed?
        end

        def test_autobench_client
            @autobench.client.benchmark
            assert @autobench["requests"] < 100 # connections

            # or...
            assert @autobench.client.passed?
        end
    end

