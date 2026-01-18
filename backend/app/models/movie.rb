class Movie < ApplicationRecord
	has_many :articles
	has_many :ratings
end
