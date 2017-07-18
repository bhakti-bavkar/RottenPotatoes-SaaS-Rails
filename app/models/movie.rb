class Movie < ActiveRecord::Base

  #before_save :capitalize_title
  #def capitalize_title
  #  self.title = self.title.split(/\s+/).map(&:downcase).
  #    map(&:capitalize).join(' ')
  #end
  
  def self.all_ratings
    ['G','PG','PG-13','R','NC-17']
  end
  
  @@grandfathered_date = Date.parse('1 Nov 1968')

  validates :title, :presence => true
  validates :release_date, :presence => true
  validate :released_1930_or_later # uses custom validator below
  validates :rating, :inclusion => {:in => Movie.all_ratings},
    :unless => :grandfathered?
  
  def released_1930_or_later
    errors.add(:release_date, 'must be 1930 or later') if
      release_date && release_date < Date.parse('1 Jan 1930')
  end
  def grandfathered?
    release_date && release_date < @@grandfathered_date
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
