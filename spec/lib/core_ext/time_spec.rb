require 'spec_helper'

describe Time do
  describe '#oid' do
    it 'should be an object id' do
      expect(Time.new(2014,02,01).oid).to eq(BSON::ObjectId.from_time(Time.parse('2014/02/01')))
    end
  end
end
