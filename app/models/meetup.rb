class Meetup < ActiveRecord::Base
  has_many :attendees
  has_many :users, through: :attendees
  belongs_to :user, :foreign_key => :creator_id
  validates :creator_id, numericality: true
  validates :name, presence: true
  validates :description, presence: true
  validates :location, presence: true
  validates :date, presence: true
end
