require "minitest/autorun"
require "minitest/spec"
require "autobench"

describe "when I run autobench" do

	before do
		@autobench ||= Autobench.new("./config/mervine.yml")
	end

	describe "render" do
		it "should pass thresholds" do
      @autobench.render.benchmark
      @autobench.render.passed?.should.be true
		end
	end

	describe "client" do
		it "should pass thresholds" do
      @autobench.client.benchmark
      @autobench.client.passed?.should.be true
		end
	end

	describe "yslow" do
		it "should pass thresholds" do
      @autobench.yslow.benchmark
      @autobench.yslow.passed?.should.be true
		end
	end

end