class Oystercard

  attr_reader :balance, :entry_station, :journeys

  BALANCE_LIMIT = 90.00
  MINIMUM_FARE = 1.00

  def initialize
    @balance = 0.00
    @entry_station = nil
    @journeys = []
    @current_journey = { entry_station: nil, exit_station: nil }
  end

  def top_up(amount)
    message = "£#{amount} top up failed, balance will exceed £#{BALANCE_LIMIT}"
    raise message if maximum_exceeded?(amount)
    @balance += amount
  end

  def touch_in(station)
    balance_error = 'Insufficient balance'
    raise balance_error if balance_too_low
    @current_journey[:entry_station] = station
    @entry_station = station
  end

  def touch_out(station)
    deduct(MINIMUM_FARE)
    @entry_station = nil
    @current_journey[:exit_station] = station
    @journeys.push(@current_journey)
  end

  def in_journey?
    @entry_station != nil
  end

  private

  def deduct(amount)
    @balance -= amount
  end

  def balance_too_low
    @balance < MINIMUM_FARE
  end

  def maximum_exceeded?(amount)
    @balance + amount > BALANCE_LIMIT
  end

end
