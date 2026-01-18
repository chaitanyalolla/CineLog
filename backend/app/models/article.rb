class Article < ApplicationRecord
	validates :title, presence: true
	validates :body, presence: true, length: { minimum: 10 }
	belongs_to :user
	belongs_to :movie

	scope :published, -> {where(published: true)}
end
