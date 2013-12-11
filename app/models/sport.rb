class Sport < ActiveRecord::Base
  attr_accessible :name

  validates :name, :presence => true
  validates :ranker, :presence => true

  has_many :sport_regions
  has_many :cities, :through => :sport_regions

  def sport_regions_with_city
    sport_regions.includes(:city)
  end

  def can_destroy?
    true
  end
end
