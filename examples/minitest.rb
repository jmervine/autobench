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
