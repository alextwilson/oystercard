require 'journey_log'

describe JourneyLog do
  subject :log { described_class.new(journey_class) }
  let(:journey) { double :journey, touch_in: entry0, touch_out: exit0,
     fare: 1, exit_station: nil, entry_station: nil }
  let(:journey_class) { double :journey_class, new: journey }
  let(:entry0) { double :entry_station }
  let(:exit0) { double :exit_station }

  it 'exists' do
    expect(log).to be_a described_class
  end

  describe '#start' do
    it 'creates a new journey' do
      log.start
      expect(journey_class).to have_received(:new)
    end

    it 'adds the journey to @journeys' do
      expect(log.start).to eq [journey]
    end
  end

  describe '#finish' do
    it 'finishes a journey' do
      log.start(entry0)
      log.finish(exit0)
      expect(journey).to have_received(:touch_out)
    end
  end

  describe '#journeys'do
    it 'returns an empty copy of @journeys' do
      expect(log.journeys).to eq []
    end

    it 'returns a filled copy after a journey is started' do
      log.start
      expect(log.journeys).to eq [journey]
    end
  end
end
