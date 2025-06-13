class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.decimal :amount
      t.integer :transaction_type
      t.integer :status
      t.string :reference_id
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
