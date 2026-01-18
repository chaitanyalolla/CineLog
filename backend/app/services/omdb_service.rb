require 'httparty'

class OmdbService
  BASE_URL = "https://www.omdbapi.com/"
  API_KEY = "fb1cf7b7"

  def self.search(query)
    url = "#{BASE_URL}?apikey=#{API_KEY}&s=#{query}"
    response = HTTParty.get(url)
    if response['Response'] == 'True'
      response['Search']  # Returns array of movies
    else
      []  # Return empty array if no results
    end
  end
  
  def self.find_by_id(imdb_id)
    url = "#{BASE_URL}?apikey=#{API_KEY}&i=#{imdb_id}"
    response = HTTParty.get(url)
    if response['Response'] == 'True'
      response
    else
      nil
    end
  end
end