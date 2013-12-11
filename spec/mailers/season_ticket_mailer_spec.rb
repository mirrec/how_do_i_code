# coding: UTF-8
require "spec_helper"

describe SeasonTicketMailer do
  let(:player) { double(:player, :firstname => "Peter", :surname => "Sveter", :email => "peter@sveter.sk") }
  let(:ticket) { double(:season_ticket,
                        :player => player,
                        :price => 12.5,
                        :payment_identifier => "99556",
                        :sport_name => "Tenis",
                        :city_name => "Bratislava",
                        season_tickers_spec.rb              :due_date => Date.new(2013, 11, 25)) }

  describe "#ordered_notification" do

    subject { SeasonTicketMailer.ordered_notification(ticket) }

    it "prepare correct mailer" do
      subject.subject.should eq(I18n.t("mailers.season_ticket.ordered_notification.subject"))
      subject.to.should eq(["peter@sveter.sk"])
      subject.from.should eq([Wnm::Core.default_mail_sender])

      subject.body.encoded.should match("Peter Sveter")
      subject.body.encoded.should match("Tenis")
      subject.body.encoded.should match("Bratislava")
      subject.body.encoded.should match("12,50")
      subject.body.encoded.should match("99556")
      subject.body.encoded.should match("25.11.2013")
    end
  end

  describe "#activated_notification" do

    subject { SeasonTicketMailer.activated_notification(ticket) }

    it "prepare correct mailer" do
      subject.subject.should eq(I18n.t("mailers.season_ticket.activated_notification.subject"))
      subject.to.should eq(["peter@sveter.sk"])
      subject.from.should eq([Wnm::Core.default_mail_sender])

      subject.body.encoded.should match("Peter Sveter")
      subject.body.encoded.should match("Tenis")
      subject.body.encoded.should match("Bratislava")
    end
  end
end
