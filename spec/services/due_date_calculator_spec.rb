require_relative "../../app/services/due_date_calculator"

describe DueDateCalculator do
  describe "#calculate" do
    let(:round) { double(:round, :start_date => Date.new(2013, 12, 28)) }
    let(:season) { double(:season, :upcoming_round => round) }

    subject { described_class.new(season) }

    it "should be one date before start of upcoming_round" do
      subject.calculate.should eq Date.new(2013, 12, 27)
    end
  end
end