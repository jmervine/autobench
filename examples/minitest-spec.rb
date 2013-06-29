require "minitest/autorun"
require "autobench"

describe "when I run autobench" do

	before do
		@autobench ||= Autobench.new("./config/mervine.yml")
	end

	describe "render" do
		it "should pass thresholds" do
      @autobench.render.benchmark
      assert @autobench.render.passed?,
          "Passed:\n#{@autobench.render.successes}\nFailed:\n#{@autobench.render.failures}"
		end
	end

	describe "client" do
		it "should pass thresholds" do
      @autobench.client.benchmark
      assert @autobench.client.passed?,
          "Passed:\n#{@autobench.client.successes}\nFailed:\n#{@autobench.client.failures}"
		end
	end

	describe "yslow" do
		it "should pass thresholds" do
      @autobench.yslow.benchmark
      assert @autobench.yslow.passed?,
          "Passed:\n#{@autobench.yslow.successes}\nFailed:\n#{@autobench.yslow.failures}"
		end
	end

end