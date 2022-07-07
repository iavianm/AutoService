class CreateServices < ActiveRecord::Migration[6.1]
  def change
    create_table :services do |t|
      t.string :title
      t.text :description
      t.integer :cost
      t.belongs_to :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
