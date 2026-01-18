class CreateMovies < ActiveRecord::Migration[8.1]
  def change
    create_table :movies do |t|
      t.string :imdb_id
      t.string :title
      t.string :year
      t.string :poster_url

      t.timestamps
    end
    add_index :movies, :imdb_id, unique: true
  end
end
