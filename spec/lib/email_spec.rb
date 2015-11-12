require 'spec_helper'

describe Email do
  let(:user) { create(:user) }
  let!(:client) { double(Segment::Analytics, :identify => nil, :track => nil) }

  before do
    allow(Segment::Analytics).to receive(:new).and_return(client)
  end

  after do
    Thread.current[:segment] = nil
  end

  describe '.identify' do
    let(:identify) { described_class.identify(user) }

    it 'should create a client' do
      expect(Segment::Analytics).to receive(:new).with(:write_key => 'segment-write-key').and_return(client)

      identify
    end

    it 'should identify the user' do
      expect(client).to receive(:identify).with(
        :user_id => user.id,
        :traits => {
          :created_at => user.created_at,
          :email => user.email
        }
      )

      identify
    end
  end

  describe '.ping' do
    let(:ping) { described_class.ping(user, 'Message', {}) }

    it 'should create a client' do
      expect(Segment::Analytics).to receive(:new).and_return(client)

      ping
    end

    it 'should identify the object.user' do
      expect(described_class).to receive(:identify).with(user)

      ping
    end

    it 'should identify the user' do
      expect(described_class).to receive(:identify).with(user)

      described_class.ping user, '', {}
    end

    it 'should send the message to the client' do
      expect(client).to receive(:track).with(
        :user_id => user.id,
        :event => 'Message',
        :properties => anything
      )

      ping
    end

    it 'should send the options to the notifier' do
      expect(client).to receive(:track).with(
        :user_id => user.id,
        :event => 'Message',
        :properties => {
          :key_a => 'value1',
          :keyb => 'value2'
        }
      )

      described_class.ping user, 'Message', :key_a => 'value1', :keyb => 'value2'
    end
  end
end
