class RemoveAttendeesIndividualIndexes < ActiveRecord::Migration[5.0]
  def change
    remove_index :attendees, :user_id
    remove_index :attendees, :meetup_id
  end
end
