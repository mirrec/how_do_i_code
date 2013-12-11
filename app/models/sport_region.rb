class SportRegion < ActiveRecord::Base
  attr_accessible :city_id, :sport_id

  validates :city_id, :sport_id, :presence => true

  belongs_to :city
  belongs_to :sport

  has_many :leagues

  delegate :name, :to => :sport, :prefix => true
  delegate :name, :to => :city, :prefix => true

  def self.sports
    Sport.where(:id => pluck(:sport_id))
  end

  def self.cities_for_sport(sport_id)
    select("`sport_regions`.`id` as `value`, `cities`.`name` as `data`").where(:sport_id => sport_id).joins(:city)
  end

  def name
    "#{sport_name} #{city_name}"
  end

  def can_destroy?
    true
  end
end
