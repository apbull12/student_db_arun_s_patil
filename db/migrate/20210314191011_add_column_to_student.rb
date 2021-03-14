class AddColumnToStudent < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :status, :string, default: 'pending'
  end
end
