class AddGradesAttribute < ActiveRecord::Migration[5.0]
  def change
    add_column :grades, :is_core, :boolean, default: false
  end
end
