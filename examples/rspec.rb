#
# bundle exec rspec -f d -c ./examples/rspec.rb
#

require 'autobench'

describe "when I run autobench" do
	before do
		@autobench ||= Autobench.new("./config/mervine.yml")
	end

	describe "render" do
		it "passes thresholds" do
      @autobench.render.benchmark
      @autobench.render.failures.should.equal "none"

      # note:
      # 
      # testing "failures" over "passed?" because it will
      # provide more verbose output on what went wrong

		end
	end

	describe "client" do
		it "passes thresholds" do
      @autobench.client.benchmark
      @autobench.client.failures.should.equal "none"
		end
	end

	describe "yslow" do
		it "passes thresholds" do
      @autobench.yslow.benchmark
      @autobench.yslow.failures.should.equal "none"
		end
	end
end