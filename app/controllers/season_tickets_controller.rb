class SeasonTicketsController < ApplicationController
  before_filter :authenticate_customer!

  rescue_from SeasonManager::NoSeason, :with => :no_season_apologize

  def new
    SeasonManager.for_ordering

    @season_ticket = SeasonTicket.new
    @sports = SportRegion.sports
  end

  def cities_to_form
    render :json => SportRegion.cities_for_sport(params[:sport_id].to_i)
  end

  def create
    @season_ticket = SeasonTicket.new(params[:season_ticket])
    @season_ticket.season = SeasonManager.for_ordering
    @season_ticket.player = current_customer

    @notifiers = [
        MailerNotifier.new(SeasonTicketMailer, :ordered_notification)
    ]

    if @season_ticket.valid?
      SeasonTicketOrderer.new(@season_ticket, @notifiers).order!
      notice_message
      redirect_to wnm_core.profile_path
    else
      alert_message(:now => true)

      @sports = SportRegion.sports
      render :new
    end
  end

  def no_season_apologize
    alert_message(:action => :no_season_apologize)
    redirect_to main_app.profile_path
  end
end