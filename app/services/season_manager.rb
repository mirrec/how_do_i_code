class SeasonManager
  NoSeason = Class.new(StandardError)

  # actual league that we players are playing, if we are in the right date window
  def self.active
    Season.active
  end

  # in season break, it return next season
  def self.upcoming
    Season.upcoming
  end

  # for !!!!!!! what if we are in the last round
  def self.for_ordering
    if active && active.upcoming_round?
      active
    elsif upcoming
      upcoming
    else
      raise SeasonManager::NoSeason.new("we are missing upcoming season, create one in admin")
    end
  end
end
