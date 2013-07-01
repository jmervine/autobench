require "minitest/autorun"
require "autobench"

describe "when I run autobench" do
  before do
    @autobench ||= Autobench.new("./config/mervine.yml")
  end

  describe "render" do
    it "passes thresholds" do
      @autobench.render.benchmark
      assert @autobench.render.passed?,
        "Passed:\n#{@autobench.render.successes}\nFailed:\n#{@autobench.render.failures}"

      # OR test something not mentioned in the thresholds list
      # of your config.
      assert @autobench.render['connection_time_85_pct'] < 500
    end
  end

  describe "client" do
    it "passes thresholds" do
      @autobench.client.benchmark
      assert @autobench.client.passed?,
          "Passed:\n#{@autobench.client.successes}\nFailed:\n#{@autobench.client.failures}"

      # OR test something not mentioned in the thresholds list
      # of your config.
      assert @autobench.client["redirects"] <= 3
      assert @autobench.client["ajaxRequests"] <= 2
    end
  end

  describe "yslow" do
    it "passes thresholds" do
      @autobench.yslow.benchmark
      assert @autobench.yslow.passed?,
          "Passed:\n#{@autobench.yslow.successes}\nFailed:\n#{@autobench.yslow.failures}"
    end
  end
end
