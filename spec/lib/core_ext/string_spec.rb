require 'spec_helper'

describe String do
  describe '#oid' do
    subject { 'foo'.oid }

    it { should == nil }

    describe 'for an object id string' do
      let(:time) { Time.at(1388519999) }

      subject { '52c3223f0000000000000000'.oid }

      it { should == BSON::ObjectId.from_time(time) }
      its(:oid) { should == BSON::ObjectId.from_time(time) }
    end
  end
end
