class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.string :payload, limit: 160, null: false
      t.integer :message_type, limit: 2, default: 0, null: false
      t.datetime :created_at
    end
  end
end
