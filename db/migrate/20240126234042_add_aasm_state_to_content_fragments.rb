class AddAasmStateToContentFragments < ActiveRecord::Migration[7.1]
  def change
    add_column :content_fragments, :aasm_state, :string
  end
end
