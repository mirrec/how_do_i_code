require "spec_helper"

describe RoundRegion do
  let(:round) { create(:round) }
  let(:sport_region) { create(:sport_region) }

  subject{ RoundRegion.new(round, sport_region) }

  describe "#groups" do
    it "returns groups that have any league from given sport_region and are in given round" do
      league = create(:league, :sport_region => sport_region)

      create(:group, :round => round)
      group = create(:group, :league => league, :round => round)
      create(:group, :league => league)

      subject.groups.should eq [group]
    end
  end

  describe "#leagues" do
    it "returns leagues from group sorted by league level in ascending order" do
      league_1 = create(:league, :sport_region => sport_region, :level => 2)
      league_2 = create(:league, :sport_region => sport_region, :level => 1)
      league_3 = create(:league, :sport_region => sport_region, :level => 3)
      create(:league)

      create(:group, :round => round)
      create(:group, :league => league_1, :round => round)
      create(:group, :league => league_2, :round => round)
      create(:group, :league => league_3)

      subject.leagues.should eq [league_2, league_1]
    end
  end

  describe "#players" do
    it "returns players from groups that are from given sport_region and round" do
      league = create(:league, :sport_region => sport_region)

      peter = create(:player)
      lukas = create(:player)
      martin = create(:player)
      alex = create(:player)
      harry = create(:player)

      create(:group, :league => league, :round => round, :players => [peter, lukas])
      create(:group, :league => league, :round => round, :players => [harry])
      create(:group, :league => league,                  :players => [lukas, martin])
      create(:group,                    :round => round, :players => [alex])

      subject.players.should eq [peter, lukas, harry]
    end
  end

  describe "#matches" do
    pending
  end

  describe "#league_level_for_players" do
    it "creates hash with player_id as kye and his league level as value" do
      league_1 = create(:league, :sport_region => sport_region, :level => 1)
      league_2 = create(:league, :sport_region => sport_region, :level => 2)

      peter = create(:player)
      lukas = create(:player)
      harry = create(:player)

      create(:group, :league => league_1, :round => round, :players => [peter, lukas])
      create(:group, :league => league_2, :round => round, :players => [harry])

      expected_hash = {
          peter.id => 1,
          lukas.id => 1,
          harry.id => 2
      }
      subject.league_level_for_players.should eq(expected_hash)
    end
  end
end