require 'journey'

describe Journey do
  subject :journey { described_class.new }
  let(:station0) { double :station }
  let(:station1) { double :station }

  it 'is created with no stations when created with no arguments' do
    expect(journey.entry_station).to eq nil
  end

  it 'is created with an entry station when given an argument' do
    journey = described_class.new(station0)
    expect(journey.entry_station).to eq station0
  end

  describe '#touch_in' do
    it 'sets entry station when given station as an argument' do
      journey.touch_in(station0)
      expect(journey.entry_station).to eq station0
    end
  end

  describe '#touch_out' do
    it 'sets entry station when given station as an argument' do
      journey.touch_out(station1)
      expect(journey.exit_station).to eq station1
    end
  end

  describe '#fare' do
    it "calculates minimum fare of #{Journey::MINIMUM_FARE}" do
      journey.touch_in(station0)
      journey.touch_out(station0)
      expect(journey.fare).to eq Journey::MINIMUM_FARE
    end

    it "returns penalty fare of #{Journey::PENALTY_FARE} when only touch out" do
      journey.touch_out(station0)
      expect(journey.fare).to eq Journey::PENALTY_FARE
    end

    it "returns penalty fare of #{Journey::PENALTY_FARE} when only touch in" do
      journey.touch_in(station0)
      expect(journey.fare).to eq Journey::PENALTY_FARE
    end

  end

  describe '#incomplete?' do
    it 'returns true for incomplete when no touch in' do
      journey.touch_in(station1)
      expect(journey.incomplete?).to eq true
    end

    it 'returns true for incomplete when no touch out' do
      journey.touch_out(station1)
      expect(journey.incomplete?).to eq true
    end

    it 'returns false for incomplete after touch in and touch out' do
      journey.touch_in(station0)
      journey.touch_out(station1)
      expect(journey.incomplete?).to eq false
    end
  end
end
