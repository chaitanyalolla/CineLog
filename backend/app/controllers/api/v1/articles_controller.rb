module Api
	module V1
		class ArticlesController < ApplicationController
			protect_from_forgery with: :null_session

			include Authenticable
			before_action :authenticate_request!

			def index
				@articles = @current_user.articles.includes(:movie).order(created_at: :desc)
				render json: @articles.as_json(include: {
			    movie: { only: [:imdb_id, :title, :poster_url, :year] }
			  })
			end

			def show
				@article = Article.find(params[:id])
				@movie = @article.movie
				render json: { 
					article: @article,
					movie: @movie
				}
			rescue ActiveRecord::RecordNotFound
				render json: { error: 'Article not found' }, status: :not_found
			end

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

				@article = @current_user.articles.build(article_params)
				@article.movie_id = @movie.id
				if @article.save
					render json: @article, status: :created
				else
					render json: { errors: @article.errors.full_messages },
					status: :unprocessable_entity
				end
			end

			def update
				@article = @current_user.articles.find(params[:id])
				if @article.update(article_params)
					render json: @article
				else
					render json: { errors: @article.errors.full_messages },
					status: :unprocessable_entity
				end
			rescue ActiveRecord::RecordNotFound
				render json: { error: 'Article not found' }, status: :not_found
			end

			def destroy
				@article = @current_user.articles.find(params[:id])
				@article.destroy
				head :no_content
			rescue ActiveRecord::RecordNotFound
				render json: { error: 'Article not found' }, status: :not_found
			end

			private
			
			def article_params
				params.require(:article).permit(:title, :body, :published, :movie_id)
			end
		end
	end
end