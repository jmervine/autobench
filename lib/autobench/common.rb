class Autobench
  module Common
    def [](key)
      full_results[key.to_sym]
    end

    def clean_keys results, ignored
      raise "missing benchmarks" unless @full_results
      results.each_key do |key|
        results.delete(key) if ignored.include?(key)
      end
      return results
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

    def thresholds?
      return !@thresholds.empty?
    end

  end
end

