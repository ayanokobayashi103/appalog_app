class AddOwnerRefToReviews < ActiveRecord::Migration[5.2]
  def change
    add_reference :reviews, :owner, foreign_key: true
  end
end
