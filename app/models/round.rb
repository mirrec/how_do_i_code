class Round < ActiveRecord::Base
  attr_accessible :season_id, :start_date, :end_date, :sequence, :name

  belongs_to :season

  has_many :groups

  validates :name, :presence => true
  validate :round_beginning_validation

  delegate :name, :to => :season, :prefix => true

  def date_range
    start_date..end_date
  end

  def full_name
    "#{I18n.t("rounds.n_round", :n => sequence)} (#{name})"
  end

  def previous
    Round.where('id != ?', id).order('id desc').first
  end

  def last_in_season?
    season.last_round.id == id
  end

  private

  def round_beginning_validation
    errors.add(:start_date, :invalid_start_date) if start_date > end_date
  end
end
