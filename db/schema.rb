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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160126183801) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "tax_office_id"
    t.string   "name"
    t.string   "email"
    t.string   "cc_emails"
    t.string   "nip"
    t.string   "phone"
    t.string   "token"
    t.string   "vat_type",       limit: 10
    t.string   "tax_type",       limit: 10
    t.boolean  "has_employees",             default: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.boolean  "send_sms",                  default: false
    t.boolean  "is_deleted",                default: false
    t.string   "contact_person"
    t.string   "regon"
  end

  add_index "companies", ["token"], name: "index_companies_on_token", unique: true, using: :btree
  add_index "companies", ["user_id", "nip"], name: "index_companies_on_user_id_and_nip", using: :btree
  add_index "companies", ["user_id"], name: "index_companies_on_user_id", using: :btree

  create_table "companies_employees", id: false, force: :cascade do |t|
    t.integer "company_id"
    t.integer "employee_id"
  end

  add_index "companies_employees", ["employee_id", "company_id"], name: "index_companies_employees_on_employee_id_and_company_id", using: :btree
  add_index "companies_employees", ["employee_id"], name: "index_companies_employees_on_employee_id", using: :btree

  create_table "email_messages", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.string   "recipient"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "email_messages", ["company_id"], name: "index_email_messages_on_company_id", using: :btree
  add_index "email_messages", ["user_id"], name: "index_email_messages_on_user_id", using: :btree

  create_table "invoices", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "last_number",                             default: 0
    t.string   "invoice_number"
    t.string   "title"
    t.date     "create_date"
    t.date     "trade_date"
    t.date     "payment_date"
    t.string   "item_name"
    t.decimal  "price",          precision: 10, scale: 2, default: 0.0
    t.decimal  "vat",            precision: 10, scale: 2, default: 1.23
    t.boolean  "gross_price",                             default: true
    t.boolean  "paid",                                    default: false
    t.boolean  "proforma",                                default: false
    t.string   "payment_type",                            default: "przelew"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
  end

  add_index "invoices", ["user_id"], name: "index_invoices_on_user_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.string   "source",      limit: 20
    t.string   "destination", limit: 20, default: "email"
    t.string   "recipients"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
  end

  create_table "payrolls", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "employee_id",    default: 0
    t.integer  "company_id"
    t.date     "period"
    t.string   "filename"
    t.boolean  "is_sent",        default: false
    t.datetime "sent_at"
    t.integer  "viewed_counter", default: 0
    t.datetime "viewed_at"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "payrolls", ["company_id"], name: "index_payrolls_on_company_id", using: :btree
  add_index "payrolls", ["is_sent"], name: "index_payrolls_on_is_sent", using: :btree
  add_index "payrolls", ["user_id", "employee_id"], name: "index_payrolls_on_user_id_and_employee_id", using: :btree

  create_table "tax_amounts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "employee_id"
    t.integer  "company_id"
    t.date     "period"
    t.decimal  "vat",                         precision: 10, scale: 2, default: 0.0
    t.decimal  "income_tax",                  precision: 10, scale: 2, default: 0.0
    t.decimal  "pit_4",                       precision: 10, scale: 2, default: 0.0
    t.decimal  "pit_8",                       precision: 10, scale: 2, default: 0.0
    t.boolean  "is_sent",                                              default: false
    t.datetime "sent_at"
    t.integer  "viewed_counter",                                       default: 0
    t.datetime "viewed_at"
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
    t.string   "message",        limit: 1000
    t.boolean  "is_sent_vat",                                          default: false
  end

  add_index "tax_amounts", ["company_id"], name: "index_tax_amounts_on_company_id", using: :btree
  add_index "tax_amounts", ["is_sent"], name: "index_tax_amounts_on_is_sent", using: :btree
  add_index "tax_amounts", ["is_sent_vat"], name: "index_tax_amounts_on_is_sent_vat", using: :btree
  add_index "tax_amounts", ["user_id", "employee_id"], name: "index_tax_amounts_on_user_id_and_employee_id", using: :btree

  create_table "tax_offices", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.string   "bank_name"
    t.string   "vat_account"
    t.string   "cit_account"
    t.string   "pit_account"
    t.string   "pcc_account"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "postcode"
    t.string   "city"
    t.string   "prefix",      limit: 99
  end

  add_index "tax_offices", ["city"], name: "index_tax_offices_on_city", using: :btree
  add_index "tax_offices", ["prefix"], name: "index_tax_offices_on_prefix", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "company_name"
    t.string   "nip"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "phone",                  limit: 128
    t.integer  "company_counter",                    default: 0
    t.boolean  "is_paid",                            default: false
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "encrypted_password",                 default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "failed_attempts",                    default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.boolean  "is_active"
    t.integer  "owner",                              default: 0
    t.string   "plain_pass"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["is_active"], name: "index_users_on_is_active", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "zus_amounts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "employee_id"
    t.integer  "company_id"
    t.date     "period"
    t.string   "payment_type",   limit: 2,                             default: "S"
    t.decimal  "us",                          precision: 10, scale: 2, default: 0.0
    t.decimal  "uz",                          precision: 10, scale: 2, default: 0.0
    t.decimal  "fp",                          precision: 10, scale: 2, default: 0.0
    t.decimal  "ep",                          precision: 10, scale: 2, default: 0.0
    t.boolean  "is_sent",                                              default: false
    t.datetime "sent_at"
    t.integer  "viewed_counter",                                       default: 0
    t.datetime "viewed_at"
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
    t.string   "message",        limit: 1000
  end

  add_index "zus_amounts", ["company_id"], name: "index_zus_amounts_on_company_id", using: :btree
  add_index "zus_amounts", ["is_sent"], name: "index_zus_amounts_on_is_sent", using: :btree
  add_index "zus_amounts", ["user_id", "employee_id"], name: "index_zus_amounts_on_user_id_and_employee_id", using: :btree

end
