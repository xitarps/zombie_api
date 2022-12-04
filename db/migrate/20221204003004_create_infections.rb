class CreateInfections < ActiveRecord::Migration[7.0]
  def change
    create_table :infections, id: :uuid do |t|
      t.references :survivor, type: :uuid, null: false, foreign_key: {to_table: :survivors}
      t.references :informer, type: :uuid, null: false, foreign_key: {to_table: :survivors}

      t.timestamps
    end
  end
end
