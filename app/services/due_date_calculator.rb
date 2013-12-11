require "active_support/time"

class DueDateCalculator
  def initialize(season)
    @season = season
  end

  def calculate
    @season.upcoming_round.start_date - 1.day
  end
end