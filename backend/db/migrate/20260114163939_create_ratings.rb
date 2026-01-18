class CreateRatings < ActiveRecord::Migration[8.1]
  def change
    create_table :ratings do |t|
      t.integer :movie_id
      t.integer :user_id
      t.integer :score

      t.timestamps
    end
    add_index :ratings, [:user_id, :movie_id], unique: true
  end
end
