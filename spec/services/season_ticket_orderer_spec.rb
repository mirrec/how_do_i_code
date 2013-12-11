require_relative "../../app/services/season_ticket_orderer"

describe SeasonTicketOrderer do
  describe "#order!" do
    it "should call order! on ticket and notify all notifiers" do
      ticket = double(:ticket)
      notifier = double(:notifier)

      season_ticket = SeasonTicketOrderer.new(ticket, [notifier])

      ticket.should_receive(:order!).and_return(ticket)
      notifier.should_receive(:notify).with(ticket)
      season_ticket.order!
    end
  end
end