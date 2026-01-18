module Api
	module V1
		class RatingsController < ApplicationController
			protect_from_forgery with: :null_session
			include Authenticable
			before_action :authenticate_request!
			
			def create
			  @movie = Movie.find_by(imdb_id: params[:movie_id])
			  
			  unless @movie
			    omdb_data = OmdbService.find_by_id(params[:movie_id])
			    @movie = Movie.create(
			      imdb_id: omdb_data['imdbID'],
			      title: omdb_data['Title'],
			      year: omdb_data['Year'],
			      poster_url: omdb_data['Poster']
			    )
			  end
			  
			  @rating = current_user.ratings.build(
			    movie_id: @movie.id,
			    score: params[:score]
			  )
			  
			  if @rating.save
			    render json: @rating, status: :created
			  else
			    render json: { errors: @rating.errors.full_messages }, status: :unprocessable_entity
			  end
			end
			def update
			  @rating = current_user.ratings.find(params[:id])
			  
			  if @rating.update(score: params[:score])
			    render json: @rating, status: :ok
			  else
			    render json: { errors: @rating.errors.full_messages }, status: :unprocessable_entity
			  end
			rescue ActiveRecord::RecordNotFound
			  render json: { error: 'Rating not found' }, status: :not_found
			end

			def destroy
			  @rating = current_user.ratings.find(params[:id])
			  
			  if @rating.destroy
			    render json: { message: 'Rating deleted' }, status: :ok
			  else
			    render json: { errors: @rating.errors.full_messages }, status: :unprocessable_entity
			  end
			rescue ActiveRecord::RecordNotFound
			  render json: { error: 'Rating not found' }, status: :not_found
			end

			private

			def rating_params
			  params.require(:rating).permit(:score)
			end
		end
	end
end