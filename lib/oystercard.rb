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
    charge_last if is_complete?(:exit_station)
    new_journey(station)
  end

  def touch_out(station)
    new_journey if is_complete?(:entry_station) || @journeys.empty?
    @current_journey.touch_out(station)
    deduct(@current_journey.fare)
  end

  def in_journey?
    !!@current_journey
  end

  private

  def deduct(amount)
    @balance -= amount
  end

  def new_journey(station = nil)
    @current_journey = @journey_class.new(station)
    @journeys << @current_journey
  end

  def charge_last
    deduct(@journeys[-1].fare)
  end

  def is_complete?(entry_or_exit_station)
    @journeys.length >= 1 and @journeys[-1].send(entry_or_exit_station) == nil
  end

  def balance_too_low
    @balance < @journey_class.minimum_fare
  end

  def maximum_exceeded?(amount)
    @balance + amount > BALANCE_LIMIT
  end
end
