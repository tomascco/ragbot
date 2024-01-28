class AddContentFragmentIndexTable < ActiveRecord::Migration[7.1]
  def up
    execute <<~SQL
      create virtual table vss_content_fragments using vss0(
        embedding(4096)
      );
    SQL
  end

  def down
    execute <<~SQL
      drop table if exists vss_content_fragments;
    SQL
  end
end
