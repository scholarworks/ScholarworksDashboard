class Item < ActiveRecord::Base
  has_many :events
  has_many :bitstreams
  belongs_to :collection
end
