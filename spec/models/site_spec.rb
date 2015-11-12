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
    end
  end

  describe '#url' do
    before do
      subject.url = 'google.com'
    end

    it 'should httpify the url' do
      expect(subject.url).to eq('http://google.com')
    end
  end
end
