class Community < ActiveRecord::Base
  has_many :collections
  has_many :events
  has_many :subcommunities, class_name: "Community", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Community", optional: true
end
