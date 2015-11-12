require 'spec_helper'

describe Users do
  describe '#create' do
    let(:response) { xhr :post, :create, :email => 'john+9@example.com' }

    it 'should be a 201' do
      expect(response.code).to eq('201')
    end

    it 'should create the user' do
      expect {
        response
      }.to change(User, :count).by(1)
    end

    it 'should have the email' do
      response

      user = User.latest
      expect(user.email).to eq('john+9@example.com')
    end

    it 'should return the user' do
      json = JSON.parse(response.body)

      user = User.latest
      expect(json['user']).to eq(JSON.parse(user.to_json))
    end

    describe 'when a user exists by email' do
      let!(:user) { create(:user, :email => 'john+9@example.com') }

      it 'should not create a user' do
        expect {
          response
        }.not_to change(User, :count)
      end

      it 'should return the user' do
        json = JSON.parse(response.body)

        expect(json['user']).to eq(JSON.parse(user.to_json))
      end
    end
  end
end
