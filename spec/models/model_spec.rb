require 'spec_helper'

describe Model do
  describe '.earliest' do
    before do
      @earliest1 = create(:user, :_id => 3.days.ago.oid)
      @earliest2 = create(:user, :_id => (3.days+2.seconds).ago.oid)
      @earliest3 = create(:user, :_id => 3.weeks.ago.oid)
    end

    it 'should be the last document' do
      expect(User.earliest).to eq(@earliest3)
    end

    describe 'n items' do
      it 'should be the last 1 document' do
        expect(User.earliest(1).to_a).to eq([@earliest3])
      end

      it 'should be the last 2 documents' do
        expect(User.earliest(2).to_a).to eq([@earliest3, @earliest2])
      end

      it 'should be the last 3 documents' do
        expect(User.earliest(3).to_a).to eq([@earliest3, @earliest2, @earliest1])
        expect(User.earliest(4).to_a).to eq([@earliest3, @earliest2, @earliest1])
        expect(User.earliest(9).to_a).to eq([@earliest3, @earliest2, @earliest1])
      end
    end
  end

  describe '.latest' do
    before do
      @latest1 = create(:user, :_id => 3.days.ago.oid)
      @latest2 = create(:user, :_id => (3.days+2.seconds).ago.oid)
      @latest3 = create(:user, :_id => 3.weeks.ago.oid)
    end

    it 'should be the last document' do
      expect(User.latest).to eq(@latest1)
    end

    describe 'n items' do
      it 'should be the last 1 document' do
        expect(User.latest(1).to_a).to eq([@latest1])
      end

      it 'should be the last 2 documents' do
        expect(User.latest(2).to_a).to eq([@latest1, @latest2])
      end

      it 'should be the last 3 documents' do
        expect(User.latest(3).to_a).to eq([@latest1, @latest2, @latest3])
        expect(User.latest(4).to_a).to eq([@latest1, @latest2, @latest3])
        expect(User.latest(9).to_a).to eq([@latest1, @latest2, @latest3])
      end
    end
  end
end
