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

ActiveRecord::Schema[8.1].define(version: 2026_06_01_212502) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "article_comment_votes", force: :cascade do |t|
    t.bigint "article_comment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.boolean "vote", null: false
    t.index ["article_comment_id", "user_id"], name: "index_article_comment_votes_on_article_comment_id_and_user_id", unique: true
    t.index ["article_comment_id"], name: "index_article_comment_votes_on_article_comment_id"
    t.index ["user_id"], name: "index_article_comment_votes_on_user_id"
  end

  create_table "article_comments", force: :cascade do |t|
    t.bigint "article_id", null: false
    t.text "body", null: false
    t.integer "children_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.integer "depth", default: 0, null: false
    t.bigint "parent_id"
    t.integer "popularity", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["article_id"], name: "index_article_comments_on_article_id"
    t.index ["parent_id"], name: "index_article_comments_on_parent_id"
    t.index ["user_id"], name: "index_article_comments_on_user_id"
  end

  create_table "article_votes", force: :cascade do |t|
    t.bigint "article_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.boolean "vote", null: false
    t.index ["article_id", "user_id"], name: "index_article_votes_on_article_id_and_user_id", unique: true
    t.index ["article_id"], name: "index_article_votes_on_article_id"
    t.index ["user_id"], name: "index_article_votes_on_user_id"
  end

  create_table "articles", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.integer "popularity", default: 0
    t.boolean "published"
    t.string "ref"
    t.string "slug"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "bio"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.integer "role"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "article_comment_votes", "article_comments"
  add_foreign_key "article_comment_votes", "users"
  add_foreign_key "article_comments", "article_comments", column: "parent_id"
  add_foreign_key "article_comments", "articles"
  add_foreign_key "article_comments", "users"
  add_foreign_key "article_votes", "articles"
  add_foreign_key "article_votes", "users"
  add_foreign_key "articles", "users"
end
