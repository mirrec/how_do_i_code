require_relative "../../app/services/season_manager"

class Season

end

describe SeasonManager do
  describe ".for_ordering" do
    context "active season have upcoming_round" do
      it "should return active season" do
        active_season = double(:season, :upcoming_round? => true)
        Season.stub(:active).and_return(active_season)

        SeasonManager.for_ordering.should eq active_season
      end
    end

    context "active has not upcomming_round" do
      it "should return upcoming_season" do
        active_season = double(:season, :upcoming_round? => false)
        upcoming_season = double(:season)
        Season.stub(:active).and_return(active_season)
        Season.stub(:upcoming).and_return(upcoming_season)

        SeasonManager.for_ordering.should eq upcoming_season
      end
    end

    context "no active season" do
      it "should return upcoming season" do
        upcoming_season = double(:season)
        Season.stub(:active).and_return(nil)
        Season.stub(:upcoming).and_return(upcoming_season)

        SeasonManager.for_ordering.should eq upcoming_season
      end
    end

    context "no active and no upcoming season" do
      it "should raise exception" do
        Season.stub(:active).and_return(nil)
        Season.stub(:upcoming).and_return(nil)

        expect{ SeasonManager.for_ordering }.to raise_error(SeasonManager::NoSeason)
      end
    end
  end
end