class List < ApplicationRecord
  acts_as_list

  has_many :cards, ->{ order(position: :asc)}, dependent: :destroy

  scope :sorted, ->{ includes(:cards).order(position: :asc) }

  validates :name, presence: true
end
