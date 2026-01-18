class AddMovieIdToArticles < ActiveRecord::Migration[8.1]
  def change
    add_column :articles, :movie_id, :integer
    add_index :articles, [:user_id, :movie_id], unique: true
  end
end
