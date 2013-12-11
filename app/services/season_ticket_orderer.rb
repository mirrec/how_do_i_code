class SeasonTicketOrderer
  def initialize(ticket, notifiers = [])
    @ticket = ticket
    @notifiers = notifiers
  end

  def order!
    @ticket.order!
    @notifiers.each{ |notifier| notifier.notify(@ticket) }
  end
end
