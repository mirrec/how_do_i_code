require 'spec_helper'

describe SportRegion do
  describe ".sports" do
    it "should return uniq sports from sport_regions" do
      bratislava = create(:city)
      kosice = create(:city)

      tennis = create(:sport)
      golf = create(:sport)
      badminton = create(:sport)

      create(:sport_region, :sport => tennis, :city => bratislava)
      create(:sport_region, :sport => tennis, :city => kosice)
      create(:sport_region, :sport => badminton, :city => bratislava)

      described_class.sports.should eq [tennis, badminton]
    end
  end

  describe "cities_for_sport" do
    it "should get city names and sport region ids for sport" do
      bratislava = create(:city)
      kosice = create(:city)

      tennis = create(:sport)
      golf = create(:sport)
      badminton = create(:sport)

      sr_bratislava = create(:sport_region, :sport => tennis, :city => bratislava)
      sr_kosice = create(:sport_region, :sport => tennis, :city => kosice)
      create(:sport_region, :sport => badminton, :city => bratislava)

      SportRegion.cities_for_sport(tennis.id).map(&:value).should eq [sr_bratislava.id, sr_kosice.id]
      SportRegion.cities_for_sport(tennis.id).map(&:data).should eq [bratislava.name, kosice.name]
    end
  end
end
