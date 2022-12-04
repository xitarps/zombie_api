class AddColumnInfectedToSurvivor < ActiveRecord::Migration[7.0]
  def change
    add_column :survivors, :infected, :boolean, default: false
  end
end
