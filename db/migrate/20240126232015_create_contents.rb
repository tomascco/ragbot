class CreateContents < ActiveRecord::Migration[7.1]
  def change
    create_table :contents do |t|
      t.string :name
      t.json :metadata

      t.timestamps
    end
  end
end
