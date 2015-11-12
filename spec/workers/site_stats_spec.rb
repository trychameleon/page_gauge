require 'spec_helper'

describe SiteStats do
  let(:site) { create(:site) }

  describe '#perform' do
    let(:perform) { subject.perform(site) }

    before do
      allow(Hookly::Message).to receive(:create)

      Sidekiq.redis {|r| r.incrby('sites:count', 4) }
    end

    it 'should increment the number of sites' do
      perform

      expect(Sidekiq.redis {|r| r.get('sites:count') }).to eq('5')
    end

    it 'should post the message to hookly' do
      expect(Hookly::Message).to receive(:create).with('#stats', { sites: { count: 5 } })

      perform
    end
  end
end
