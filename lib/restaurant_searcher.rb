# coding: utf-8

require 'json'

TIME_SUFFIX = 30 * 60 # 移動時間などの考慮（分）
RESTAURANT_DEF = File.expand_path( 'data/restaurants.json' )

class RestaurantSearcher

  def initialize
    @restaurants = JSON.load( File.open RESTAURANT_DEF )
    @candidates = create_candidates
  end

  def create_candidates
    [] if @restaurants.empty?

    now = Time.now
    now_hour, now_min  = Time.now.hour, Time.now.min
    candidates = []

    # 現在時刻が範囲内にあるものだけ candidates に入れる
    @restaurants.each do |restaurant| # Enumerable#inject で書けそう
      open = restaurant["open"]
      from_hour, from_min = open["from"].split( ':' ).map{ |time| time.to_i }
      from_time = Time.local( now.year, now.month, now.day, from_hour, from_min )

      to_hour, to_min = open["to"].split( ':' ).map { |time| time.to_i }
      to_time = Time.local( now.year, now.month, now.day, to_hour, to_min )
      to_time -= TIME_SUFFIX

      candidates << restaurant if from_time <= now && now < to_time
    end
    candidates
  end

  def all_candidates
    @candidates
  end

  def all_restraunts
    @restaurants
  end

  def next_candidate
    @candidates.empty? ? nil : @candidates.sample
  end
  # private :next_candidate

  def next_candidate_name
    candidate = next_candidate
    candidate ? candidate["name"] : "候補なし"
  end

end
