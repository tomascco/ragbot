class CreateContentFragments < ActiveRecord::Migration[7.1]
  def change
    create_table :content_fragments do |t|
      t.string :body
      t.json :metadata
      t.references :content, null: false, foreign_key: true

      t.timestamps
    end
  end
end
