require 'spec_helper'

describe Home do
  describe '#index' do
    let(:response) { get :index }

    it 'should be a 200' do
      expect(response.code).to eq('200')
    end

    it 'should render the view' do
      expect(response).to render_template('home/index')
    end
  end
end
