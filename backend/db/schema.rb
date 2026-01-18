# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_01_14_163949) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "articles", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.integer "movie_id"
    t.boolean "published"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id", "movie_id"], name: "index_articles_on_user_id_and_movie_id", unique: true
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "movies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "imdb_id"
    t.string "poster_url"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "year"
    t.index ["imdb_id"], name: "index_movies_on_imdb_id", unique: true
  end

  create_table "ratings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "movie_id"
    t.integer "score"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id", "movie_id"], name: "index_ratings_on_user_id_and_movie_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "articles", "users"
end
