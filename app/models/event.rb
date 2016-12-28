class Event < ActiveRecord::Base
  belongs_to :community, optional: true
  belongs_to :collection, optional: true
  belongs_to :user, optional: true
  belongs_to :item, optional: true
  belongs_to :bitstream, optional: true
end
