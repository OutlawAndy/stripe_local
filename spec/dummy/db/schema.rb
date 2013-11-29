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

ActiveRecord::Schema.define(version: 20131122063517) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stripe_local_balances", force: true do |t|
    t.integer  "available"
    t.integer  "pending"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stripe_local_cards", id: false, force: true do |t|
    t.string   "id"
    t.string   "customer_id"
    t.string   "name"
    t.integer  "exp_month"
    t.integer  "exp_year"
    t.string   "brand"
    t.string   "last4"
    t.string   "cvc_check"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stripe_local_cards", ["customer_id"], name: "index_stripe_local_cards_on_customer_id", using: :btree
  add_index "stripe_local_cards", ["id"], name: "index_stripe_local_cards_on_id", unique: true, using: :btree

  create_table "stripe_local_charges", id: false, force: true do |t|
    t.string   "id"
    t.string   "card_id"
    t.string   "customer_id"
    t.string   "invoice_id"
    t.string   "transaction_id"
    t.integer  "amount"
    t.boolean  "captured",        default: true
    t.boolean  "refunded",        default: false
    t.boolean  "paid"
    t.datetime "created"
    t.string   "currency",        default: "usd"
    t.integer  "amount_refunded", default: 0
    t.string   "description"
    t.string   "failure_code"
    t.string   "failure_message"
    t.text     "metadata"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stripe_local_charges", ["card_id"], name: "index_stripe_local_charges_on_card_id", using: :btree
  add_index "stripe_local_charges", ["customer_id"], name: "index_stripe_local_charges_on_customer_id", using: :btree
  add_index "stripe_local_charges", ["id"], name: "index_stripe_local_charges_on_id", unique: true, using: :btree
  add_index "stripe_local_charges", ["invoice_id"], name: "index_stripe_local_charges_on_invoice_id", using: :btree
  add_index "stripe_local_charges", ["transaction_id"], name: "index_stripe_local_charges_on_transaction_id", using: :btree

  create_table "stripe_local_coupons", id: false, force: true do |t|
    t.string   "id"
    t.integer  "percent_off"
    t.integer  "amount_off"
    t.string   "currency",           default: "usd"
    t.string   "duration"
    t.datetime "redeem_by"
    t.integer  "max_redemptions"
    t.integer  "times_redeemed",     default: 0
    t.integer  "duration_in_months"
    t.boolean  "synced",             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stripe_local_coupons", ["id"], name: "index_stripe_local_coupons_on_id", unique: true, using: :btree

  create_table "stripe_local_customers", id: false, force: true do |t|
    t.string   "id"
    t.integer  "account_balance"
    t.string   "default_card"
    t.boolean  "delinquent"
    t.string   "description"
    t.string   "email"
    t.integer  "model_id"
    t.text     "metadata"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stripe_local_customers", ["id"], name: "index_stripe_local_customers_on_id", unique: true, using: :btree
  add_index "stripe_local_customers", ["model_id"], name: "index_stripe_local_customers_on_model_id", using: :btree

  create_table "stripe_local_discounts", force: true do |t|
    t.string   "coupon_id"
    t.string   "subscription_id"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stripe_local_discounts", ["coupon_id", "subscription_id"], name: "index_stripe_local_discounts_on_coupon_id_and_subscription_id", using: :btree

  create_table "stripe_local_invoices", id: false, force: true do |t|
    t.string   "id"
    t.string   "customer_id"
    t.integer  "amount_due"
    t.integer  "subtotal"
    t.integer  "total"
    t.boolean  "attempted"
    t.integer  "attempt_count"
    t.boolean  "paid"
    t.boolean  "closed"
    t.datetime "date"
    t.datetime "period_start"
    t.datetime "period_end"
    t.string   "currency",             default: "usd"
    t.integer  "starting_balance"
    t.integer  "ending_balance"
    t.string   "charge_id"
    t.integer  "discount",             default: 0
    t.integer  "application_fee"
    t.datetime "next_payment_attempt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stripe_local_invoices", ["customer_id"], name: "index_stripe_local_invoices_on_customer_id", using: :btree
  add_index "stripe_local_invoices", ["id"], name: "index_stripe_local_invoices_on_id", unique: true, using: :btree

  create_table "stripe_local_line_items", id: false, force: true do |t|
    t.string   "id"
    t.string   "invoice_id"
    t.boolean  "subscription", default: true
    t.integer  "amount"
    t.string   "currency",     default: "usd"
    t.boolean  "proration"
    t.datetime "period_start"
    t.datetime "period_end"
    t.integer  "quantity"
    t.string   "plan_id"
    t.string   "description"
    t.text     "metadata"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stripe_local_line_items", ["id"], name: "index_stripe_local_line_items_on_id", unique: true, using: :btree
  add_index "stripe_local_line_items", ["invoice_id"], name: "index_stripe_local_line_items_on_invoice_id", using: :btree

  create_table "stripe_local_plans", id: false, force: true do |t|
    t.string   "id"
    t.string   "name"
    t.integer  "amount"
    t.string   "interval"
    t.integer  "interval_count",    default: 1
    t.integer  "trial_period_days", default: 0
    t.string   "currency",          default: "usd"
    t.boolean  "synced",            default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stripe_local_plans", ["id"], name: "index_stripe_local_plans_on_id", unique: true, using: :btree

  create_table "stripe_local_subscriptions", force: true do |t|
    t.string   "customer_id"
    t.string   "plan_id"
    t.string   "status"
    t.integer  "quantity",             default: 1
    t.datetime "start"
    t.datetime "canceled_at"
    t.datetime "ended_at"
    t.datetime "current_period_start"
    t.datetime "current_period_end"
    t.datetime "trial_start"
    t.datetime "trial_end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stripe_local_subscriptions", ["customer_id"], name: "index_stripe_local_subscriptions_on_customer_id", using: :btree
  add_index "stripe_local_subscriptions", ["plan_id"], name: "index_stripe_local_subscriptions_on_plan_id", using: :btree

  create_table "stripe_local_transactions", id: false, force: true do |t|
    t.string   "id"
    t.integer  "amount"
    t.datetime "available_on"
    t.datetime "created"
    t.integer  "fee"
    t.integer  "net"
    t.string   "source_id"
    t.string   "source_type"
    t.string   "status"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stripe_local_transactions", ["id"], name: "index_stripe_local_transactions_on_id", unique: true, using: :btree
  add_index "stripe_local_transactions", ["source_id", "source_type"], name: "index_transactions_on_source_id_and_source_type", using: :btree
  add_index "stripe_local_transactions", ["status"], name: "index_stripe_local_transactions_on_status", using: :btree

  create_table "stripe_local_transfers", id: false, force: true do |t|
    t.string   "id"
    t.integer  "amount"
    t.datetime "date"
    t.string   "status"
    t.string   "transaction_id"
    t.string   "description"
    t.text     "metadata"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stripe_local_transfers", ["id"], name: "index_stripe_local_transfers_on_id", unique: true, using: :btree
  add_index "stripe_local_transfers", ["status"], name: "index_stripe_local_transfers_on_status", using: :btree
  add_index "stripe_local_transfers", ["transaction_id"], name: "index_stripe_local_transfers_on_transaction_id", using: :btree

end
