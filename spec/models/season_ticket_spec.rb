require 'spec_helper'

describe SeasonTicket do
  describe "validation" do
    it "validates sport_region_id present" do
      t = SeasonTicket.new
      t.should_not be_valid
      t.should have(1).error_on(:sport_region_id)
    end

    it "validates season_id present" do
      t = SeasonTicket.new
      t.should_not be_valid
      t.should have(1).error_on(:season_id)
    end

    it "validates player_id present" do
      t = SeasonTicket.new
      t.should_not be_valid
      t.should have(1).error_on(:player_id)
    end

    it "validates sport_id presents if validate_sport_id is true" do
      t = SeasonTicket.new
      t.should_not be_valid
      t.should have(1).error_on(:sport_id)
    end

    it "validates uniqness of sport_id" do
      tennis = create(:sport)
      sport_region = create(:sport_region, :sport => tennis)
      st = create(:season_ticket, :sport_region => sport_region)

      t = SeasonTicket.new(:player_id => st.player_id, :sport_region_id => create(:sport_region, :sport => tennis).id, :season_id => st.season_id)
      t.should_not be_valid
      t.should have(1).error_on(:sport_region_id)

      t = SeasonTicket.new(:player_id => st.player_id, :sport_region_id => create(:sport_region, :sport => create(:sport)).id, :season_id => st.season_id)
      t.should be_valid
    end

    it "validates sport_id is equal to sport_region.sport_id" do
      tennis = create(:sport)
      sport_region = create(:sport_region, :sport => tennis)

      t = SeasonTicket.new
      t.sport_id = tennis.id + 1
      t.sport_region = sport_region
      t.should_not be_valid
      t.should have(1).error_on(:sport_region_id)
    end

    it "should allow to update record and pass unique validation" do
      st = create(:season_ticket)
      st.should be_valid
    end
  end

  describe ".payed" do
    it "finds payed tickets" do
      create(:season_ticket, :status => "ordered")
      payed = create(:season_ticket, :status => "payed")
      create(:season_ticket, :status => "ordered")

      SeasonTicket.payed.map(&:id).should eq([payed].map(&:id))
    end
  end

  describe ".for_sport_region" do
    it "finds tickets from given sport_region" do
      sport_region = create(:sport_region)
      create(:season_ticket)
      expected = create(:season_ticket, :sport_region => sport_region)
      create(:season_ticket)

      SeasonTicket.for_sport_region(sport_region).map(&:id).should eq([expected].map(&:id))
    end
  end

  describe ".for_season" do
    it "finds tickets from given season" do
      season = create(:season)
      create(:season_ticket)
      expected = create(:season_ticket, :season => season)
      create(:season_ticket)

      SeasonTicket.for_season(season).map(&:id).should eq([expected].map(&:id))
    end
  end

  describe ".payed_for_region_season" do
    it "finds active tickets from given sport_region and season" do
      sport_region = create(:sport_region)
      season = create(:season)

      create(:season_ticket)
      expected = create(:season_ticket, :status => "payed", :sport_region => sport_region, :season => season)
      create(:season_ticket, :status => "ordered", :sport_region => sport_region, :season => season)
      create(:season_ticket, :season => season, :status => "payed")
      create(:season_ticket, :sport_region => sport_region, :status => "payed")
      create(:season_ticket, :status => "payed")

      SeasonTicket.payed_for_region_season(sport_region, season).map(&:id).should eq([expected].map(&:id))
    end
  end

  describe ".for_region_season" do
    pending
  end

  describe "#order!" do
    it "should count price, set status to :ordered and save ticket" do
      player = create(:player)
      season = create(:season)
      sport_region = create(:sport_region)

      PriceList.stub(:price_for_season).and_return(20.1)
      ticket = SeasonTicket.new(:player_id => player.id, :season_id => season.id, :sport_region_id => sport_region.id)
      ticket.order!

      ticket.price.should eq 20.1
      ticket.status.to_sym.should eq :ordered
      ticket.should be_persisted
    end
  end

  describe "#pay!" do
    it "should set status to :payed and save ticket" do
      ticket = create(:season_ticket, :status => :ordered)
      ticket.pay!
      ticket.status.to_sym.should eq :payed
    end
  end

  describe "#payed?" do
    it "is true if status is :payed or 'payed'" do
      ticket = SeasonTicket.new
      ticket.should_not be_payed

      ticket.status = :payed
      ticket.should be_payed

      ticket.status = "payed"
      ticket.should be_payed
    end
  end

  describe "#activate!" do
    it "should set status to :active and save ticket" do
      ticket = create(:season_ticket, :status => :ordered)
      group = create(:group)
      ticket.activate!(group)
      ticket.status.to_sym.should eq :active
      ticket.group_id.should eq group.id
    end
  end

  describe "#active?" do
    it "is true if status is :active or 'active'" do
      ticket = SeasonTicket.new
      ticket.should_not be_active

      ticket.status = :active
      ticket.should be_active

      ticket.status = "active"
      ticket.should be_active
    end
  end

  describe "#deactivate!" do
    it "should set status to :inactive and save ticket" do
      ticket = create(:season_ticket, :status => :active)
      ticket.deactivate!
      ticket.status.to_sym.should eq :inactive
    end
  end

  describe "#inactive?" do
    it "is true if status is :inactive or 'inactive'" do
      ticket = SeasonTicket.new
      ticket.should_not be_inactive

      ticket.status = :inactive
      ticket.should be_inactive

      ticket.status = "inactive"
      ticket.should be_inactive
    end
  end

  describe "#payment_identifier" do
    it "is id" do
      subject.id = 333
      subject.payment_identifier.should eq 333
    end
  end

  describe "#calculate_price" do
    it "should calculate price for season from ticket" do
      season = build(:season)
      ticket = SeasonTicket.new
      ticket.season = season

      PriceList.should_receive(:price_for_season).with(season, SeasonPriceRules).and_return(25.4)
      ticket.calculate_price.should eq 25.4
    end
  end

  describe "#sport_id" do
    it "should return instance variable if it is set" do
      ticket = SeasonTicket.new
      ticket.sport_id = 55
      ticket.sport_id.should eq 55
    end

    it "should return sport_id from sport_region if instance variable is not set" do
      tennis = create(:sport)

      ticket = SeasonTicket.new
      ticket.sport_region = create(:sport_region, :sport => tennis)
      ticket.sport_id.should eq tennis.id
    end
  end
end
