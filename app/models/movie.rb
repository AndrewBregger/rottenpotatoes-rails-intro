class Movie < ActiveRecord::Base
#   attr_accessor :title, :rating, :description, :release_date
    def ratings
      ['G', 'PG', 'PG-13', 'R']
    end
end