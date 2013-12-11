class SeasonTicketMailer < ActionMailer::Base
  layout "layouts/email"
  default :from => Wnm::Core.default_mail_sender, :bcc => Wnm::Core.default_mail_sender

  def ordered_notification(ticket)
    @ticket = ticket
    @player = ticket.player
    mail :to => @player.email, :subject => t("mailers.season_ticket.ordered_notification.subject")
  end

  def activated_notification(ticket)
    @ticket = ticket
    @player = ticket.player
    mail :to => @player.email, :subject => t("mailers.season_ticket.activated_notification.subject")
  end
end