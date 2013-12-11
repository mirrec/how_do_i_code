require 'spec_helper'

describe Round do
  describe "validation" do
    it "validates name presence" do
      r = build :round, :name => nil

      r.should_not be_valid
      r.should have(1).error_on(:name)
    end

    it 'should have valid date range' do
      round = build :round, start_date: Date.today, end_date: Date.tomorrow

      round.should be_valid
      round.errors[:start_date].should be_empty
    end

    it 'should not be valid if start date preceeds end date' do
      round = build :round, start_date: Date.tomorrow, end_date: Date.today

      round.should_not be_valid
      round.errors[:start_date].should_not be_empty
    end
  end

  describe "#full_name" do
    it "join sequence name with name" do
      round = Round.new(:sequence => 3, :name => "hello")
      round.full_name.should eq "3. kolo (hello)"
    end
  end
end
