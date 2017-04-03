class CreateAttendees < ActiveRecord::Migration[5.0]
  def change
    create_table :attendees do |t|
      t.belongs_to :user
      t.belongs_to :meetup
    end
    add_index :attendees, [:user_id, :meetup_id], unique: true
  end
end
