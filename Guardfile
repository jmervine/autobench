# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :bundler do
  watch("Gemfile")
end

#guard "shell", :all_on_start => true do
  #watch(%r{^test/(.*)\/?test_(.*)\.rb}) do |m|
    #`bundle exec ruby -Ilib -Itest -rlib/autobench ./test/#{m[0]}/#{m[1]}_test.rb`
  #end
#end


guard 'minitest', :version => 5,
                  :bundler => true do

  # with Minitest::Unit
  watch(%r|^test/(.*)\/?(.*)_test\.rb|)
  watch(%r|^lib/(.*)([^/]+)\.rb|)     { |m| "test/#{m[1]}#{m[2]}_test.rb" }
  watch(%r|^test/test_helper\.rb|)    { "test" }
end

# vim: ft=ruby:
