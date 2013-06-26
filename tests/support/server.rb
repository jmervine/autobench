require 'sinatra'

get '/fast' do
  "fast"
end

get '/slow' do
  sleep 1
  "slow"
end
