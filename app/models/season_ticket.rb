class SeasonTicket < ActiveRecord::Base
  attr_accessible :season_id, :player_id, :sport_region_id, :price, :sport_id, :expected_level

  attr_accessor :sport_id

  belongs_to :season
  belongs_to :player, :class_name => 'Wnm::Customer'
  belongs_to :sport_region
  belongs_to :group

  has_many :player_round_levels, :foreign_key => :ticket_id

  validates :season_id, :player_id, :sport_region_id, :sport_id, :presence => true
  validate :sport_id_equal_validation, :unique_ticket_validation

  delegate :sport_name, :city_name, :to => :sport_region_was
  delegate :name, :to => :season, :prefix => true


  scope :payed, lambda{ where(:status => "payed") }
  scope :for_sport_region, lambda{ |sport_region_id| where(:sport_region_id => sport_region_id) }
  scope :for_season, lambda{ |season_id| where(:season_id => season_id) }
  scope :for_profile, lambda{ where(:status => ["ordered", "payed", "active"]) }

  def self.payed_for_region_season(region, season)
    payed.for_region_season(region, season)
  end

  def self.for_region_season(region, season)
    for_sport_region(region).for_season(season)
  end

  def self.statuses
    {
        :ordered => I18n.t("season_tickets.attributes.statuses.ordered"),
        :payed => I18n.t("season_tickets.attributes.statuses.payed"),
        :active => I18n.t("season_tickets.attributes.statuses.active")
    }
  end

  def status_human
    self.class.statuses[status.to_sym] if status
  end

  def name
    [player.name, sport_name, city_name].join(" - ")
  end

  def order!
    self.price = calculate_price
    self.status = :ordered
    save!
    self
  end

  def ordered?
    status.to_s == :ordered.to_s
  end

  def pay!
    self.status = :payed
    save!
    self
  end

  def payed?
    status.to_s == :payed.to_s
  end

  def activate!(group)
    self.group = group
    self.status = :active
    save!
    self
  end

  def active?
    status.to_s == :active.to_s
  end

  def deactivate!
    self.status = :inactive
    save!
    self
  end

  def inactive?
    status.to_s == :inactive.to_s
  end

  def payment_identifier
    id
  end

  def due_date
    @due_date ||= DueDateCalculator.new(season).calculate
  end

  def calculate_price
    PriceList.price_for_season(season, SeasonPriceRules)
  end

  def can_destroy?
    true
  end

  def sport_id
    @sport_id ||= sport_region.try(:sport_id)
  end

  def sport
    sport_region.sport
  end

  def expected_level_name
    ExpectedLevel.find_by_id(expected_level) if expected_level
  end

  private

  def sport_id_equal_validation
    if sport_id.to_i != sport_region.try(:sport_id).to_i
      errors.add(:sport_region_id, I18n.t("custom_errors.validation.bad_sport"))
    end
  end

  def unique_ticket_validation
    if SeasonTicket.where(:season_id => season_id, :player_id => player_id, :sport_region_id => SportRegion.where(:sport_id => sport_id).map(&:id), :id.not_eq => id).exists?
      errors.add(:sport_region_id, I18n.t("custom_errors.validation.duplicate_ticket"))
    end
  end

  def sport_region_was
    @sport_region_orig ||= sport_region || SportRegion.find_by_id(sport_region_id_was)
  end
end
