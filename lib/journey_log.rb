require_relative 'journey'

class JourneyLog

  def initialize(journey_class = Journey)
    @journey_class = journey_class
    @journeys = []
  end

  def start(entry_station = nil)
    @journeys << @journey_class.new(entry_station)
  end

  def finish(exit_station)
    current_journey.touch_out(exit_station)
  end

  def journeys
    @journeys.dup
  end

  private
  def current_journey
    return @journeys[-1] if @journeys[-1].exit_station == nil
    start
  end
end
