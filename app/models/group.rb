class Group < ActiveRecord::Base
  attr_accessible :league_id, :round_id, :sequence, :players

  belongs_to :league
  belongs_to :round

  has_many :group_has_players
  has_many :players, :through => :group_has_players
  has_many :posts
  has_many :season_tickets
  has_many :matches

  delegate :level, :to => :league, :prefix => true
  delegate :sport_name, :to => :league

  def self.create_with_players(number, players, league, round)
    group = create!(:sequence => number, :league_id => league.id, :round_id => round.id)
    group.players = players
    group.save!
    group
  end

  def name
    ("A".."Z").to_a[sequence.to_i - 1]
  end

  def matches_ids
    matches.map(&:id)
  end
end
