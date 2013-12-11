class Season < ActiveRecord::Base
  attr_accessible :name, :rounds_attributes

  validates :name, :presence => true
  validate :rounds_dates_validation

  has_many :rounds

  accepts_nested_attributes_for :rounds

  def self.active
    joins(:rounds).group(:id).having("MIN(rounds.start_date) <= ?", Date.today).having("MAX(rounds.end_date) >= ?", Date.today).first
  end

  def self.upcoming
    joins(:rounds).group(:id).having("MIN(rounds.start_date) > ?", Date.today).first
  end

  def build_rounds
    4.times { |x| self.rounds << Round.new(:sequence => x + 1, :start_date => Date.today + x, :end_date => Date.today + x) }
  end

  def started_rounds
    rounds.length - future_rounds.count
  end

  def upcoming_round
    future_rounds.first
  end

  def upcoming_round?
    upcoming_round.present?
  end

  def start_date
    rounds.first.start_date if rounds.any?
  end

  def end_date
    rounds.last.end_date if rounds.any?
  end

  def last_round
    rounds.last
  end

  private

  def future_rounds
    rounds.to_a.select { |round| Date.today < round.start_date }
  end

  def total_days
    rounds.map { |round| round.date_range.count }.sum
  end

  def rounds_dates_validation
    days = rounds.map(&:date_range).map(&:to_a).flatten.uniq

    if days.count != total_days
      errors.add(:rounds, :intersecting_dates)
    end
  end
end
