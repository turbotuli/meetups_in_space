class ChangeMeetupsDateField < ActiveRecord::Migration[5.0]
  def change
    change_column :meetups, :date, :date
  end
end
