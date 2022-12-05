class CreatePositions < ActiveRecord::Migration[7.0]
  def change
    create_table :positions, id: :uuid do |t|
      t.decimal :latitude, null: false, precision: 10, scale: 6
      t.decimal :longitude, null: false, precision: 10, scale: 6
      t.references :survivor, null: false, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
