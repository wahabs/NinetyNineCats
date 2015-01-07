class AddUserIdToCatRentalRequests < ActiveRecord::Migration
  def change
    add_reference :cat_rental_requests, :user, index: true
  end
end
