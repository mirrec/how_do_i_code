class GroupHasPlayer < ActiveRecord::Base
  attr_accessible :group_id, :player_id

  belongs_to :group
  belongs_to :player, :class_name => "Wnm::Customer"
end
