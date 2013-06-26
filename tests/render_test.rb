require "minitest/autorun"
require "autobench"

## Mock Httperf#run to parse static results
class HTTPerf
  def run
    $verbose_raw ||= File.open("./tests/support/dummy_verbose_results.txt","r").read
    return Parser.parse($verbose_raw)
  end
end

class TestAutobenchRender < Minitest::Test
  def setup
    @abrender ||= Autobench::Render.new(Autobench::Config.new("./config/config.yml"))
  end

  def test_initialize
    assert Autobench::Render.new(Autobench::Config.new("./config/config.yml"))
    assert Autobench::Render.new(Autobench::Config.new("./config/config.yml")).instance_variable_get(:@config)
  end

  def test_benchmark
    results = @abrender.benchmark
    assert_equal "169.5", results["connection_time_median"]
  end

  def test_passed?
    @abrender.benchmark
    assert @abrender.passed?
    refute @abrender.failed?

    # make fail condition
    @abrender.instance_variable_get(:@config)["thresholds"]["render"]["connection_time_99_pct"] = 1
    refute @abrender.passed?
    assert @abrender.failed?
  end
end

# vim: ft=ruby:
