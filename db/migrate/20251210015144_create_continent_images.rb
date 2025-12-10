class CreateContinentImages < ActiveRecord::Migration[7.1]
  def change
    create_table :continent_images do |t|
      t.string :name
      t.references :continent, null: false, foreign_key: true
      t.boolean :public

      t.timestamps
    end
  end
end
