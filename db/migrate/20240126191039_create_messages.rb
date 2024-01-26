class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.references :conversation, null: false, foreign_key: true
      t.text :text
      t.boolean :from_system

      t.timestamps
    end
  end
end
