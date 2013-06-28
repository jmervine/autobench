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

### TODO: Usage

    autobench -c ./path/to/config.yml

### DONE: Minitest Integration

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

