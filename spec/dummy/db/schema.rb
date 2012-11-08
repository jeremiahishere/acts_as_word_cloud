# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121107162154) do

  create_table "articles", :force => true do |t|
    t.integer  "author_id"
    t.integer  "publisher_id"
    t.integer  "site_id"
    t.string   "title"
    t.string   "genre"
    t.text     "content"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "articles", ["author_id"], :name => "index_articles_on_author_id"
  add_index "articles", ["publisher_id"], :name => "index_articles_on_publisher_id"
  add_index "articles", ["site_id"], :name => "index_articles_on_site_id"

  create_table "authors", :force => true do |t|
    t.integer  "publisher_id"
    t.integer  "site_id"
    t.string   "name"
    t.string   "genre"
    t.integer  "age"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "authors", ["publisher_id"], :name => "index_authors_on_publisher_id"
  add_index "authors", ["site_id"], :name => "index_authors_on_site_id"

  create_table "followings", :force => true do |t|
    t.string  "special_name"
    t.integer "article_id"
    t.integer "reader_id"
  end

  add_index "followings", ["article_id"], :name => "index_followings_on_article_id"
  add_index "followings", ["reader_id"], :name => "index_followings_on_reader_id"

  create_table "publishers", :force => true do |t|
    t.string   "name"
    t.string   "location"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "readers", :force => true do |t|
    t.integer  "site_id"
    t.string   "username"
    t.integer  "age"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "readers", ["site_id"], :name => "index_readers_on_site_id"

  create_table "sites", :force => true do |t|
    t.integer  "publisher_id"
    t.string   "name"
    t.string   "domain"
    t.string   "genre"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "sites", ["publisher_id"], :name => "index_sites_on_publisher_id"

end
