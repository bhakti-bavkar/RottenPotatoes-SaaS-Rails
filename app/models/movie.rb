class Movie < ActiveRecord::Base
  def self.all_ratings
        ['G','PG','PG-13','R','NC-17']
  end
  
  def self.search_movies_by_director(director)
    Movie.where(:director => director)
  end

  def self.default_settings
      settings = Hash.new
      ratings = {}
      all_ratings.each {|rating| ratings[rating] = 1}
      settings[:ratings] = ratings 
      settings[:column] = nil
      settings
  end
    
  def self.filter_and_sort(filter,sort)
      return Movie.all if filter.nil? and sort.nil?
      if sort.nil?
          return Movie.where(:rating => filter.keys)
      else
          return Movie.where(:rating => filter.keys).order(sort)
      end
  end
      
end
