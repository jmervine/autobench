class Autobench
  module Common
    def [](key)
      full_results[key.to_sym]
    end

    def full_results
      raise "missing benchmarks" unless @full_results
      @full_results
    end

    def failures
      return "none" if passed?
      out = ""
      @failures.each_with_index do |f,i|
        out << "[#{i+1}] #{f}\n"
      end
      return out
    end

    def successes
      raise "missing benchmarks" unless @full_results
      return "none" if @successes.empty?
      out = ""
      @successes.each_with_index do |f,i|
        out << "[#{i+1}] #{f}\n"
      end
      return out
    end

    def passed?
      raise "missing benchmarks" unless @full_results
      return @failures.empty?
    end

    def failed?
      !passed?
    end

  end
end

