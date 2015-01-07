class AddUserIdToCats < ActiveRecord::Migration
  def change
    add_reference :cats, :user, index: true
  end
end
