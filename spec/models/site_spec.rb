require 'spec_helper'

describe Site do
  subject { build(:site) }

  describe 'validations' do
    it { should be_valid }

    it 'requires an url' do
      subject.url = nil
      expect(subject).not_to be_valid
    end
  end

  describe 'presentation' do
    its(:allows) { should == %i(url) }
    its(:allows_json) { should == %i(url code headers body redirect_count duration raw) }
  end

  describe '#save' do
    describe 'on create' do
      it 'should fetch the url' do
        expect(SiteFetch).to receive(:new).with(subject).and_return(fetch = instance_double(SiteFetch))
        expect(fetch).to receive(:run)

        subject.save
      end

      it 'should update the site stats' do
        expect(SiteStats).to receive(:perform_async).with(subject.id)

        subject.save
      end
    end
  end

  describe '#url' do
    before do
      subject.url = 'google.com'
    end

    it 'should httpify the url' do
      expect(subject.url).to eq('http://google.com')
    end

    describe 'for a wonky url' do
      before do
        subject.url = 'googlE.com/Hi'
      end

      it 'should convert to lower case' do
        expect(subject.url).to eq('http://google.com/hi')
      end
    end
  end
end
