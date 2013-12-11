require_relative "../../app/services/price_list"
require_relative "../../app/services/season_price_rules"

describe PriceList do
  describe ".price_for_season" do
    it "should count price for active rounds (total round - started_rounds)" do
      season = double(:season, :started_rounds => 0)
      PriceList.price_for_season(season, SeasonPriceRules).should eq 12.0

      season = double(:season, :started_rounds => 1)
      PriceList.price_for_season(season, SeasonPriceRules).should eq 10.0

      season = double(:season, :started_rounds => 2)
      PriceList.price_for_season(season, SeasonPriceRules).should eq 8.0

      season = double(:season, :started_rounds => 3)
      PriceList.price_for_season(season, SeasonPriceRules).should eq 6.0
    end
  end
end