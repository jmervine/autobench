# autobench

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
            results = @autobench.render
            assert results["connection_time_median"] < 500 # ms

            # or...
            results = @autobench.render
            assert results.passed?
        end

        def test_autobench_yslow
            results = @autobench.yslow
            assert results.overall >= 95 # score
        end

        def test_autobench_client
            results = @autobench.client
            assert results.median < 500 # ms
        end
    end

