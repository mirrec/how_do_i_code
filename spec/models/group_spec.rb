require 'spec_helper'

describe Group do
  describe ".create_with_players" do
    it "should create new group and map players to it" do
      players = [
          create(:player),
          create(:player)
      ]

      league = create(:league)
      round = create(:round)

      group = Group.create_with_players(1, players, league, round)

      Group.should have(1).record

      group.sequence.should eq 1
      group.players.to_a.should eq(players)
      group.league_id.should eq(league.id)
      group.round_id.should eq(round.id)
    end
  end

  describe "#name" do
    it "return number according to sequence number" do
      group = Group.new(:sequence => 1)
      group.name.should eq "A"

      group.sequence = 4
      group.name.should eq "D"

      group.sequence = 26
      group.name.should eq "Z"
    end
  end
end
