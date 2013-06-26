# autobench

> NOTE: This is still very much under development.

### Installation

    gem install autobench

    # or...

    bundle init
    echo "gem 'autobench'" >> Gemfile
    bundle install --path vendor/bundle

### Usage

    autobench -c ./path/to/config.yml

### Minitest Integration

    require "minitest/autorun"
    require "autobench"

    class TestBenchmarks < Minitest::Test
        def setup
            @autobench = Autobench.new( "./path/to/config.yml", { ... config overides ... } )
        end

        def test_autobench_render
            results = @autobench.render.benchmark
            assert results["connection_time_median"] < 500 # ms

            # or...
            assert @autobench.render.passed?
        end

        def test_autobench_yslow
            results = @autobench.yslow.benchmark
            assert results["overall"] >= 95 # score

            # or...
            assert @autobench.yslow.passed?
        end

        def test_autobench_client
            results = @autobench.client.benchmark
            assert results["load_key"] < 500 # ms

            # or...
            assert @autobench.client.passed?
        end
    end

