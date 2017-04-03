class Attendee < ActiveRecord::Base
  belongs_to :user
  belongs_to :meetup
  validates :meetup_id, numericality: true
  validates :user_id, numericality: true
end
