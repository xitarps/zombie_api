class AddColumnTokenToSurvivor < ActiveRecord::Migration[7.0]
  def change
    add_column :survivors, :token, :string, null: false
  end
end
