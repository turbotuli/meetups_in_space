class CreateMeetups < ActiveRecord::Migration[5.0]
  def change
    create_table :meetups do |t|
      t.integer :creator_id, null: false
      t.string :name, null: false
      t.string :description, null: false
      t.string :location, null: false
      t.datetime :date, null: false

      t.timestamps null: false
    end
  end
end
