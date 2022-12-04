class AddUniqueIndexToInfection < ActiveRecord::Migration[7.0]
  def change
    add_index :infections, [:informer_id, :survivor_id], unique: true
  end
end
