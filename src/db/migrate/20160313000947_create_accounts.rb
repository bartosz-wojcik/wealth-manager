class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :activation_key
      t.datetime :activation_expiry
      t.integer :status, default: 0
      t.datetime :last_seen

      t.timestamps null: false
    end
  end
end
