class AddUsersAttribute < ActiveRecord::Migration
  def change
    add_column :users, :verify_code,:string,default: ""
  end
end
