require 'pp'

require 'sinatra'
require File.expand_path( 'lib/restaurant_searcher.rb' )

def load
  @searcher = RestaurantSearcher.new
end

get '/' do
  load unless @searcher
  @searcher.next_candidate.to_s
  # @searcher.next_candidate_name
end

