require_relative 'journey'
class Oystercard

  attr_reader :balance, :journeys

  BALANCE_LIMIT = 90.00

  def initialize(journey_class = Journey)
    @balance = 0.00
    @journeys = []
    @journey_class = journey_class
  end

  def top_up(amount)
    message = "£#{amount} top up failed, balance will exceed £#{BALANCE_LIMIT}"
    raise message if maximum_exceeded?(amount)
    @balance += amount
  end

  def touch_in(station)
    raise 'Insufficient balance' if balance_too_low
    if @journeys.length >= 1 and @journeys[-1].exit_station == nil
      deduct(@journeys[-1].fare)
    end
    @current_journey = @journey_class.new(station)
    @journeys << @current_journey
  end

  def touch_out(station)
    @current_journey.touch_out(station)
    deduct(@current_journey.fare)
  end

  def in_journey?
    return false if @current_journey == nil
    @current_journey.in_journey?
  end

  private

  def deduct(amount)
    @balance -= amount
  end

  def balance_too_low
    @balance < @journey_class.minimum_fare
  end

  def maximum_exceeded?(amount)
    @balance + amount > BALANCE_LIMIT
  end

end
