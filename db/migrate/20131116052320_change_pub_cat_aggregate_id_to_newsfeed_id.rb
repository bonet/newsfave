class ChangePubCatAggregateIdToNewsfeedId < ActiveRecord::Migration
  def change
    remove_column :users, :pub_cat_aggregate_id
    add_column    :users, :newsfeed_aggregate_id, :integer
  end
end
