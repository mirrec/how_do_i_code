require "spec_helper"

describe Season do
  describe ".active" do
    it "finds season which rounds are in date boarders" do
      create(:season, :rounds => [create(:round, :start_date => (Date.today - 3.week), :end_date => (Date.today - 2.week))])
      active = create(:season, :rounds => [create(:round, :start_date => (Date.today - 1.week), :end_date => (Date.today + 1.week))])
      create(:season, :rounds => [create(:round, :start_date => (Date.today + 1.week), :end_date => (Date.today + 2.week))])

      Season.active.id.should eq active.id
    end

    it "returns nil if no active season was found" do
      Season.active.should be_nil
    end
  end

  describe ".upcoming" do
    it "finds closest season in future" do
      create(:season, :rounds => [create(:round, :start_date => (Date.today - 3.week), :end_date => (Date.today - 2.week))])
      create(:season, :rounds => [create(:round, :start_date => (Date.today - 1.week), :end_date => (Date.today + 1.week))])
      upcoming = create(:season, :rounds => [create(:round, :start_date => (Date.today + 1.week), :end_date => (Date.today + 2.week))])

      Season.upcoming.id.should eq upcoming.id
    end
  end

  describe "rounds" do
    let(:round_1) { Round.new(:start_date => Date.new(2013, 11, 1)) }
    let(:round_2) { Round.new(:start_date => Date.new(2013, 11, 8)) }
    let(:round_3) { Round.new(:start_date => Date.new(2013, 11, 15)) }
    let(:round_4) { Round.new(:start_date => Date.new(2013, 11, 22)) }
    let(:season_with_rounds) {
      season = Season.new
      season.rounds = [round_1, round_2, round_3, round_4]
      season
    }

    describe "#started_rounds" do
      it "counts number of rounds that already started by comparing actual Date to round start date" do
        Timecop.freeze(2013, 10, 31) do
          season_with_rounds.started_rounds.should eq 0
        end
        Timecop.freeze(2013, 11, 1) do
          season_with_rounds.started_rounds.should eq 1
        end

        Timecop.freeze(2013, 11, 22) do
          season_with_rounds.started_rounds.should eq 4
        end

        Timecop.freeze(2013, 12, 22) do
          season_with_rounds.started_rounds.should eq 4
        end
      end
    end

    describe "#upcoming_round" do
      it "returns cloasest future round" do
        Timecop.freeze(2013, 10, 31) do
          season_with_rounds.upcoming_round.should eq round_1
        end
        Timecop.freeze(2013, 11, 1) do
          season_with_rounds.upcoming_round.should eq round_2
        end

        Timecop.freeze(2013, 11, 22) do
          season_with_rounds.upcoming_round.should be_nil
        end

        Timecop.freeze(2013, 12, 22) do
          season_with_rounds.upcoming_round.should be_nil
        end
      end
    end
  end

  describe '#rounds_attributes' do
    it 'should create season with valid round dates' do
      season = build :season, :with_rounds

      season.valid?
      season.errors[:rounds].should be_empty
    end

    it 'should not create season with intersecting round dates' do
      season = build :season, rounds_attributes: [
          {
              :start_date => Date.today,
              :end_date =>   Date.today + 1.day,
          },
          {
              :start_date => Date.today + 1.day,
              :end_date =>   Date.today + 2.days
          },
          {
              :start_date => Date.today + 4.days,
              :end_date =>   Date.today + 5.days,
          },
          {
              :start_date => Date.today + 5.days,
              :end_date =>  Date.today + 7.days
          }
      ]

      season.should_not be_valid
      season.errors[:rounds].should_not be_empty
    end


    it 'should set start and end date by rounds' do
      season = create :season, :with_rounds

      season.start_date.should eql(season.rounds.first.start_date)
      season.end_date.should eql(season.rounds.last.end_date)
    end
  end

  describe "#build_rounds" do
    it "builds 4 rounds and populate sequence number" do
      season = Season.new
      season.rounds.to_a.should have(0).items

      season.build_rounds
      season.rounds.to_a.should have(4).items

      season.rounds.first.sequence.should eq 1
      season.rounds.last.sequence.should eq 4
    end
  end
end
