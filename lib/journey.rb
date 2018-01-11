class Journey
  attr_reader :entry_station, :exit_station

  MINIMUM_FARE = 1.00
  PENALTY_FARE = 6.00

  def initialize(station = nil)
    touch_in(station)
    @exit_station = nil
  end

  def touch_in(station)
    @entry_station = station
  end

  def touch_out(station)
    @exit_station = station
  end

  def fare
    return PENALTY_FARE if incomplete?
    MINIMUM_FARE
  end

  def in_journey?
    (!@entry_station.nil? and @exit_station.nil?) ? true : false
  end

  def incomplete?
    @exit_station.nil? || @entry_station.nil?
  end

end
