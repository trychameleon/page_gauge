require 'spec_helper'

describe NilClass do
  describe '#oid' do
    subject { nil.oid }

    it { should == nil }
  end
end
