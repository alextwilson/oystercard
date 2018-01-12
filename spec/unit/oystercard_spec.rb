require 'oystercard'

describe Oystercard do
  let(:journey) { double :journey, touch_in: entry0, touch_out: exit0,
     fare: 1, exit_station: nil, entry_station: entry0 }
  let(:journey_class) { double :journey_class, new: journey, minimum_fare: 1 }
  subject :card  { described_class.new(journey_class) }
  let(:entry0) { double :entry_station }
  let(:exit0) { double :exit_station }
  let(:entry1) { double :entry_station }
  let(:exit1) { double :exit_station }

  it "balance should be zero" do
    expect(card.balance).to eq 0
  end

  describe '#top_up' do

    it "top up adds to balance" do
      expect { card.top_up(2) } .to change { card.balance } .by 2
    end

    it "top up will not exceed balance limit" do
      max_balance = Oystercard::BALANCE_LIMIT
      amount = Oystercard::BALANCE_LIMIT + 1
      error = "£#{amount} top up failed, balance will exceed £#{max_balance}"
      expect { card.top_up(amount) } .to raise_error error
    end

  end

  describe '#in_journey?' do

    it 'returns false before any touches' do
      expect( card ).to_not be_in_journey
    end

  end

  describe '#touch_in' do

    it 'raises an error if balance is below 1' do
      error = 'Insufficient balance'
      expect { card.touch_in(entry0)} .to raise_error error
    end

    it 'creates new journey if there is an existing open journey' do
      card.top_up(20)
      card.touch_in(entry0)
      card.touch_in(entry1)
      expect(card.journeys).to eq [journey, journey]
    end

    it 'charges penalty fare if there is an existing open journey' do
      allow(journey).to receive(:fare).and_return 6
      card.top_up(20)
      card.touch_in(entry0)
      expect { card.touch_in(entry1) } .to change { card.balance }.by -6
    end

  end

  describe '#touch_out' do

    before do
      card.top_up(10)
    end

    it "reduces balance by 1" do
      charge = -1
      card.touch_in(entry0)
      expect { card.touch_out(exit1) } .to change { card.balance } .by charge
    end

    it 'creates new journey if there is not an open journey' do
      allow(journey).to receive(:entry_station).and_return nil
      card.touch_out(exit0)
      expect(card.journeys).to eq [journey]
    end

    it 'charges penalty fare if there have been no journeys' do
      allow(journey).to receive(:fare).and_return 6
      expect { card.touch_out(exit0) } .to change { card.balance }.by -6
    end

    it 'charges penalty fare if there is not an open journey' do
      card.touch_in(entry0)
      card.touch_out(exit0)
      allow(journey).to receive(:fare).and_return 6
      expect { card.touch_out(exit1) } .to change { card.balance }.by -6
    end

  end

end
