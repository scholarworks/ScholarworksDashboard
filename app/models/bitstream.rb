class Bitstream < ActiveRecord::Base
  has_many :events
  belongs_to :item
end
