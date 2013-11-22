class LoadStripeTables < ActiveRecord::Migration
  def change
    create_table :stripe_local_customers, id: false do |t|
      t.string  :id, primary_key: true
			t.integer :account_balance
      t.string  :default_card
      t.boolean :delinquent
      t.string  :description
      t.string  :email
      t.text    :metadata

      t.timestamps
    end
		add_index :stripe_local_customers, :id, unique: true

    create_table :stripe_local_cards, id: false do |t|
      t.string     :id, primary_key: true
      t.string     :customer_id
      t.string     :name
      t.integer    :exp_month
      t.integer    :exp_year
      t.string     :brand
      t.string     :last4
      t.string     :cvc_check

      t.timestamps
    end
		add_index :stripe_local_cards, :id, unique: true
		add_index :stripe_local_cards, :customer_id

    create_table :stripe_local_plans, id: false do |t|
      t.string   :id, primary_key: true
      t.string   :name
      t.integer  :amount
      t.string   :interval
      t.integer  :interval_count, default: 1
      t.integer  :trial_period_days, default: 0
			t.string   :currency, default: 'usd'
      t.boolean  :synced, default: false

      t.timestamps
    end
		add_index :stripe_local_plans, :id, unique: true

    create_table :stripe_local_coupons, id: false do |t|
      t.string   :id, primary_key: true
      t.integer  :percent_off
      t.integer  :amount_off
      t.string   :currency, default: 'usd'
      t.string   :duration
      t.datetime :redeem_by
      t.integer  :max_redemptions
      t.integer  :times_redeemed, default: 0
      t.integer  :duration_in_months
      t.boolean  :synced,   default: false

      t.timestamps
    end
		add_index :stripe_local_coupons, :id, unique: true

    create_table :stripe_local_discounts do |t|
      t.string :coupon_id
      t.string :subscription_id
      t.datetime :start
      t.datetime :end

      t.timestamps
    end
		add_index :stripe_local_discounts, [ :coupon_id, :subscription_id ]

    create_table :stripe_local_subscriptions do |t|
      t.string :customer_id
			t.string :plan_id
      t.string :status
      t.integer :quantity, default: 1
      t.datetime :start
      t.datetime :canceled_at
      t.datetime :ended_at
      t.datetime :current_period_start
      t.datetime :current_period_end
      t.datetime :trial_start
      t.datetime :trial_end

      t.timestamps
    end
		add_index :stripe_local_subscriptions, :customer_id
		add_index :stripe_local_subscriptions, :plan_id

    create_table :stripe_local_invoices, id: false do |t|
      t.string   :id, primary_key: true
      t.string   :customer_id
      t.integer  :amount_due
      t.integer  :subtotal
      t.integer  :total
      t.boolean  :attempted
      t.integer  :attempt_count
      t.boolean  :paid
      t.boolean  :closed
      t.datetime :date
      t.datetime :period_start
      t.datetime :period_end
      t.string   :currency, default: 'usd'
      t.integer  :starting_balance
      t.integer  :ending_balance
      t.string   :charge_id
      t.integer  :discount, default: 0
			t.integer  :application_fee
      t.datetime :next_payment_attempt

      t.timestamps
    end
		add_index :stripe_local_invoices, :id, unique: true
		add_index :stripe_local_invoices, :customer_id

    create_table :stripe_local_line_items, id: false do |t|
      t.string   :id, primary_key: true
			t.string   :invoice_id
			t.boolean  :subscription, default: true
      t.integer  :amount
      t.string   :currency, default: 'usd'
      t.boolean  :proration, dafault: false
      t.datetime :period_start
      t.datetime :period_end
			t.integer  :quantity
			t.string   :plan_id
      t.string   :description
      t.text     :metadata

      t.timestamps
    end
		add_index :stripe_local_line_items, :id, unique: true
		add_index :stripe_local_line_items, :invoice_id

    create_table :stripe_local_charges, id: false do |t|
      t.string   :id, primary_key: true
      t.string   :card_id
      t.string   :customer_id
      t.string   :invoice_id
      t.string   :transaction_id
      t.integer  :amount
      t.boolean  :captured, default: true
      t.boolean  :refunded, default: false
      t.boolean  :paid
      t.datetime :created
      t.string   :currency, default: 'usd'
      t.integer  :amount_refunded, default: 0
      t.string   :description
      t.string   :failure_code
      t.string   :failure_message
      t.text     :metadata

      t.timestamps
    end
		add_index :stripe_local_charges, :id, unique: true
		add_index :stripe_local_charges, :card_id
		add_index :stripe_local_charges, :customer_id
		add_index :stripe_local_charges, :invoice_id
		add_index :stripe_local_charges, :transaction_id

    create_table :stripe_local_transfers, id: false do |t|
      t.string  :id, primary_key: true
      t.integer :amount
      t.datetime :date
      t.string :status
      t.string :transaction_id
      t.string :description
      t.text :metadata

      t.timestamps
    end
    add_index :stripe_local_transfers, :id, unique: true
    add_index :stripe_local_transfers, :status
    add_index :stripe_local_transfers, :transaction_id

    create_table :stripe_local_transactions, id: false do |t|
      t.string   :id, primary_key: true
      t.integer  :amount
      t.datetime :available_on
      t.datetime :created
      t.integer  :fee
      t.integer  :net
      t.string   :source_id
      t.string   :source_type
      t.string   :status
      t.string   :description

      t.timestamps
    end
    add_index :stripe_local_transactions, :id, unique: true
    add_index :stripe_local_transactions, :status
    add_index :stripe_local_transactions, %i( source_id source_type ), name: 'index_transactions_on_source_id_and_source_type'

    create_table :stripe_local_balances do |t|
      t.integer :available
      t.integer :pending

      t.timestamps
    end
  end
end
