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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170726150819) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accessed_discussions", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "discussion_id", null: false
    t.datetime "accessed_at", default: -> { "now()" }, null: false
    t.index ["discussion_id"], name: "idx_accessed_discussions_discussion_id"
    t.index ["user_id", "discussion_id"], name: "idx_accessed_discussions_user_discussion", unique: true
    t.index ["user_id"], name: "idx_accessed_discussions_user_id"
  end

  create_table "accessed_sections", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "section_id", null: false
    t.datetime "accessed_at", default: -> { "now()" }, null: false
    t.index ["section_id"], name: "idx_accessed_sections_section_id"
    t.index ["user_id", "section_id"], name: "idx_accessed_sections_user_discussion", unique: true
    t.index ["user_id"], name: "idx_accessed_sections_user_id"
  end

  create_table "authors", id: :serial, force: :cascade do |t|
    t.string "pen_name", limit: 255, null: false
    t.string "real_name", limit: 255
    t.text "description"
    t.string "photo_file", limit: 255
    t.date "born_on"
    t.date "passed_away_on"
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at"
    t.integer "user_id", null: false
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "authors_pseudonyms_publications", id: :serial, force: :cascade do |t|
    t.integer "author_id", null: false
    t.integer "pseudonym_id", null: false
    t.integer "publication_id", null: false
  end

  create_table "bi_publications_facts", id: :serial, force: :cascade do |t|
    t.integer "publications_counter", default: 0, null: false
    t.integer "characters_counter", default: 0, null: false
    t.date "month", null: false
  end

  create_table "bi_users_facts", id: :serial, force: :cascade do |t|
    t.integer "registrated_counter", default: 0, null: false
    t.integer "activated_counter", default: 0, null: false
    t.integer "discussions_counter", default: 0, null: false
    t.integer "comments_counter", default: 0, null: false
    t.date "month", null: false
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.text "description"
    t.string "banner_file", limit: 255
    t.integer "hits", default: 0, null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.string "banner_file_name"
    t.string "banner_content_type"
    t.integer "banner_file_size"
    t.datetime "banner_updated_at"
  end

  create_table "categories_publications", id: :serial, force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "publication_id", null: false
  end

  create_table "collections", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.text "description"
    t.string "banner_file", limit: 255
    t.string "first_column_name", limit: 255
    t.string "second_column_name", limit: 255
    t.string "third_column_name", limit: 255
    t.string "fourth_column_name", limit: 255
    t.string "fifth_column_name", limit: 255
    t.boolean "blocked", default: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
  end

  create_table "collections_publications", id: :serial, force: :cascade do |t|
    t.integer "collection_id", null: false
    t.integer "publication_id", null: false
    t.text "first_column_value"
    t.text "second_column_value"
    t.text "third_column_value"
    t.text "fourth_column_value"
    t.text "fifth_column_value"
    t.integer "position", default: 0, null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.integer "discussion_id", null: false
    t.integer "user_id", null: false
    t.text "comment", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at"
  end

  create_table "completed_lessons", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "lesson_id", null: false
    t.datetime "completed_at", default: -> { "now()" }, null: false
    t.index ["lesson_id"], name: "idx_completed_lessons_lesson_id"
    t.index ["user_id", "lesson_id"], name: "idx_completed_lessons_user_lesson", unique: true
    t.index ["user_id"], name: "idx_completed_lessons_user_id"
  end

  create_table "courses", id: :serial, force: :cascade do |t|
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at"
    t.string "name", limit: 255, null: false
    t.string "banner_file", limit: 255
    t.text "headline"
    t.text "description"
    t.boolean "blocked", default: false, null: false
  end

  create_table "courses_prerequisites", id: :serial, force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "prerequisite_id", null: false
    t.index ["course_id", "prerequisite_id"], name: "idx_courses_prerequisites_course_prerequisite", unique: true
  end

  create_table "discussions", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.integer "user_id", null: false
    t.integer "hits", default: 0, null: false
    t.integer "comments_count", default: 1, null: false
    t.integer "last_user_id"
    t.boolean "closed", default: false, null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.integer "subject_id", null: false
    t.datetime "commented_at", default: -> { "now()" }, null: false
  end

  create_table "enrollments", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "course_id", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at"
    t.datetime "finished_at"
  end

  create_table "feedbacks", id: :serial, force: :cascade do |t|
    t.text "message", null: false
    t.text "answer"
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "answered_at"
    t.integer "user_id"
    t.text "user_agent"
    t.string "user_ip", limit: 255
    t.text "current_url", null: false
    t.text "referer_url"
  end

  create_table "images", id: :serial, force: :cascade do |t|
    t.string "file_file_name"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.datetime "file_updated_at"
    t.integer "section_id"
    t.integer "publication_id"
    t.index ["publication_id"], name: "index_images_on_publication_id"
    t.index ["section_id"], name: "index_images_on_section_id"
  end

  create_table "lessons", id: :serial, force: :cascade do |t|
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at"
    t.string "title", limit: 255, null: false
    t.text "text"
    t.integer "position", default: 0, null: false
    t.integer "course_id", null: false
  end

  create_table "login_attempts", id: :serial, force: :cascade do |t|
    t.string "login", limit: 255, null: false
    t.string "ip", limit: 255, null: false
    t.date "date", default: -> { "now()" }, null: false
    t.time "time", default: -> { "now()" }, null: false
    t.boolean "failed", default: true, null: false
    t.index ["date"], name: "index_login_attempts_date"
    t.index ["failed"], name: "index_login_attempts_failed"
    t.index ["ip"], name: "index_login_attempts_ip"
    t.index ["login"], name: "index_login_attempts_login"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.tsvector "tsv"
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
    t.index ["tsv"], name: "index_pg_search_documents_on_tsv", using: :gin
  end

  create_table "pseudonyms", id: :serial, force: :cascade do |t|
    t.integer "author_id", null: false
    t.string "name", limit: 255, null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at"
    t.integer "user_id", null: false
  end

  create_table "publications", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255, null: false
    t.string "original_title", limit: 255
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at"
    t.boolean "blocked", default: false, null: false
    t.integer "hits", default: 0, null: false
    t.string "copyright_notice", limit: 1024
    t.string "banner_file", limit: 255
    t.boolean "featured", default: false, null: false
    t.string "pdf_file", limit: 255
    t.integer "user_id"
    t.boolean "published", default: true, null: false
    t.string "banner_file_name"
    t.string "banner_content_type"
    t.integer "banner_file_size"
    t.datetime "banner_updated_at"
    t.string "pdf_file_name"
    t.string "pdf_content_type"
    t.integer "pdf_file_size"
    t.datetime "pdf_updated_at"
    t.boolean "signed_reader_only", default: false, null: false
  end

  create_table "roles_users", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "role_name", null: false
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0
  end

  create_table "sections", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at"
    t.integer "position", default: 0, null: false
    t.integer "hits", default: 0, null: false
    t.text "seo_description"
    t.string "seo_keywords", limit: 255
    t.text "text"
    t.text "source"
    t.integer "parent_id"
    t.datetime "published_at"
    t.integer "root_id"
    t.integer "publication_id", null: false
    t.integer "user_id"
    t.string "banner_file_name"
    t.string "banner_content_type"
    t.integer "banner_file_size"
    t.datetime "banner_updated_at"
  end

  create_table "subjects", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "label_background_color", limit: 6, null: false
    t.string "label_text_color", limit: 6, null: false
    t.datetime "created_at", default: -> { "now()" }
    t.datetime "updated_at", default: -> { "now()" }
    t.integer "discussions_count", default: 0, null: false
    t.integer "comments_count", default: 0, null: false
  end

  create_table "tbl_migration", primary_key: "version", id: :string, limit: 255, force: :cascade do |t|
    t.integer "apply_time"
  end

  create_table "timeline_events", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "type_id", null: false
    t.integer "referred_id"
    t.datetime "occurred_at", null: false
    t.index ["occurred_at"], name: "idx_timeline_events_occurred"
    t.index ["type_id"], name: "idx_timeline_events_type"
    t.index ["user_id"], name: "idx_timeline_events_user"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "login", limit: 255, null: false
    t.string "email", limit: 255, null: false
    t.string "encrypted_password", limit: 255, null: false
    t.string "salt", limit: 36, null: false
    t.boolean "email_confirmed", default: false, null: false
    t.boolean "blocked", default: false, null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at"
    t.datetime "last_login_at"
    t.string "last_login_ip", limit: 255
    t.string "confirmation_code", limit: 36
    t.string "password_recovery_code", limit: 36
    t.string "phpbb_password", limit: 255
    t.string "registration_ip", limit: 255, null: false
    t.string "google_id", limit: 255
    t.string "facebook_id", limit: 255
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer "comments_count", default: 0, null: false
    t.integer "discussions_count", default: 0, null: false
    t.integer "commented_discussions_count", default: 0, null: false
  end

  add_foreign_key "accessed_discussions", "discussions", name: "accessed_discussions_discussion_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "accessed_discussions", "users", name: "accessed_discussions_user_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "accessed_sections", "sections", name: "accessed_sections_section_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "accessed_sections", "users", name: "accessed_sections_user_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "authors", "users", name: "authors_user_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "authors_pseudonyms_publications", "authors", name: "authors_pseudonyms_publications_author_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "authors_pseudonyms_publications", "pseudonyms", name: "authors_pseudonyms_publications_pseudonym_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "authors_pseudonyms_publications", "publications", name: "authors_pseudonyms_publications_publication_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "categories_publications", "categories", name: "categories_publications_category_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "categories_publications", "publications", name: "categories_publications_publication_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "collections_publications", "collections", name: "collections_publications_collection_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "collections_publications", "publications", name: "collections_publications_publication_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "comments", "discussions", name: "comments_discussion_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "comments", "users", name: "comments_user_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "completed_lessons", "lessons", name: "completed_lessons_lesson_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "completed_lessons", "users", name: "completed_lessons_user_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "courses_prerequisites", "courses", column: "prerequisite_id", name: "courses_prerequisites_prerequisite_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "courses_prerequisites", "courses", name: "courses_prerequisites_course_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "discussions", "subjects", name: "discussions_subject_id_fkey", on_update: :cascade, on_delete: :nullify
  add_foreign_key "discussions", "users", column: "last_user_id", name: "discussions_last_user_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "discussions", "users", name: "discussions_user_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "enrollments", "courses", name: "enrollments_course_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "enrollments", "users", name: "enrollments_user_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "feedbacks", "users", name: "feedbacks_user_id_fkey", on_update: :cascade, on_delete: :nullify
  add_foreign_key "images", "publications"
  add_foreign_key "images", "sections"
  add_foreign_key "lessons", "courses", name: "lessons_course_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "pseudonyms", "authors", name: "pseudonyms_author_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "pseudonyms", "users", name: "pseudonyms_user_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "publications", "users", name: "publications_user_id_fkey", on_update: :cascade, on_delete: :nullify
  add_foreign_key "roles_users", "users", name: "roles_users_user_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "sections", "publications", name: "sections_publication_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "sections", "sections", column: "parent_id", name: "sections_parent_section_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "sections", "sections", column: "root_id", name: "sections_root_id_fkey", on_update: :cascade, on_delete: :restrict
  add_foreign_key "sections", "users", name: "sections_user_id_fkey", on_update: :cascade, on_delete: :nullify
  add_foreign_key "timeline_events", "users", name: "timeline_events_user_id_fkey", on_update: :cascade, on_delete: :cascade
end
