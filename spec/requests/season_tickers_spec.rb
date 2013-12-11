# coding: UTF-8
require "spec_helper"

describe "SeasonTickets" do
  let(:tennis) { create(:sport, :name => "Tennis") }
  let(:bratislava) { create(:city, :name => "Bratislava") }
  let(:player) { create(:player, :email => "jozef@gmial.com", :password => "secret") }

  it "player should be able to buy a ticket for season in sport_region", :js => true do
    SeasonPriceRules.stub(:one_round_price => 10.0)

    create(:season, :rounds => [create(:round)])
    create(:sport_region, :sport => tennis, :city => bratislava)
    player
    reset_email

    log_in_as_customer("jozef@gmial.com", "secret")

    click_link "tickets"

    click_button "order"

    page.should have_content "there are errors in form"

    select "Tennis", :from => "season_ticket_sport_id"
    select "Bratislava", :from => "season_ticket_sport_region_id"

    click_button "order"

    page.should have_content "Your league request was send successfully"

    ticket = SeasonTicket.last
    ticket.sport_region.sport.should eq tennis
    ticket.sport_region.city.should eq bratislava
    ticket.player_id.should eq player.id

    last_email.to.should include(player.email)

    last_email.body.encoded.should include("Tennis")
    last_email.body.encoded.should include("Bratislava")
    last_email.body.encoded.should include("12,00")
  end

  it "should not be possible to buy ticket when player is not logged in" do
    visit new_season_ticket_path

    current_path.should eq wnm_core.log_in_path

    page.should have_content "Log in is required"
  end

  it "should display information if no next season is available" do
    player
    reset_email
    log_in_as_customer("jozef@gmial.com", "secret")

    click_link "tickets"

    page.should have_content "Sending league request is not now not available. New season was not scheduled yet."

  end
end
