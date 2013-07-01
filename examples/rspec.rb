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

      # prints failures list generated based on thresholds
      # configuration while running #benchmark
      @autobench.render.failures.should == "none"

      # note:
      #
      # testing "failures" over "passed?" because it will
      # provide more verbose output on what went wrong

      # OR test something not mentioned in the thresholds list
      # of your config.
      @autobench.render["connection_time_85_pct"].should be < 500

    end
  end

  describe "client" do
    it "passes thresholds" do
      @autobench.client.benchmark
      @autobench.client.failures.should == "none"

      @autobench.client["redirects"].should be <= 3
      @autobench.client["ajaxRequests"].should be <= 2

    end
  end

  describe "yslow" do
    it "passes thresholds" do
      @autobench.yslow.benchmark
      @autobench.yslow.failures.should == "none"
    end
  end
end

# vim: ft=ruby:
