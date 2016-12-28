class Collection < ActiveRecord::Base
  belongs_to :community
  has_many :events
  has_many :items
end
