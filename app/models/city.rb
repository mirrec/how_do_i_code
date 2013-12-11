class City < ActiveRecord::Base
  attr_accessible :name

  validates :name, :presence => true

  has_many :sport_regions
  has_many :sports, :through => :sport_regions

  def can_destroy?
    true
  end
end
