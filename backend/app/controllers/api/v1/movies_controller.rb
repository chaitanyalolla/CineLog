module Api
	module V1
		class MoviesController < ApplicationController
			protect_from_forgery with: :null_session
			include Authenticable
			before_action :authenticate_request!
			
			def index
			  if params[:query].present?
			    omdb_response = OmdbService.search(params[:query])
			    @movies = omdb_response
			  else
			    @movies = []
			  end

			  render json: @movies
			end

			def show
			  @selected_movie = OmdbService.find_by_id(params[:id])

			  unless @selected_movie
			    redirect_to movies_path, alert: "Movie not found"
			    return
			  end
			  
			  @movie = Movie.find_by(imdb_id: params[:id])
			  
			  if @movie
			    @user_article = @movie.articles.find_by(user_id: current_user.id)
			    @user_rating = @movie.ratings.find_by(user_id: current_user.id)
			    @all_articles = @movie.articles
			  else
			    @user_article = nil
			    @user_rating = nil
			    @all_articles = []
			  end
			  render json: {
			    movie: @selected_movie,
			    user_article: @user_article,
			    user_rating: @user_rating,
			    all_articles: @all_articles
			  }
			end

		end
	end
end