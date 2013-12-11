class RoundRegion
  attr_reader :round, :sport_region

  def initialize(round, sport_region)
    @round = round
    @sport_region = sport_region
  end

  def groups
    @groups ||= ::Group.where(:round_id => round, :league_id => League.where(:sport_region_id => sport_region))
  end

  def leagues
    @leagues ||= groups.map(&:league).sort{ |league_1, league_2| league_1.level <=> league_2.level }
  end

  def players
    groups.map(&:players).flatten
  end

  def matches
    Match.for_round_region(round, sport_region)
  end

  def season_tickets
    SeasonTicket.for_region_season(sport_region, round.season)
  end

  def league_level_for_players
    player_to_league_level = {}

    groups.each do |group|
      group.player_ids.each do |player_id|
        player_to_league_level[player_id] = group.league_level
      end
    end

    player_to_league_level
  end
end