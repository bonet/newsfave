class AddPubCatAggregateIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pub_cat_aggregate_id, :integer
  end
end
