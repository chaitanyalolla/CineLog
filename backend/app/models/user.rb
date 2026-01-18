class User < ApplicationRecord
	has_secure_password
	has_many :articles, dependent: :destroy
	has_many :ratings, dependent: :destroy
	
	validates :email, presence: true, uniqueness: true
	validates :name, presence: true
end
