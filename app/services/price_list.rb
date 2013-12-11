class PriceList
  def self.price_for_season(season, season_price_rules)
    season_price_rules.full_season_price - (season_price_rules.one_round_price * season.started_rounds)
  end
end
