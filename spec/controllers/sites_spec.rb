require 'spec_helper'

describe Sites do
  let(:url) { 'http://google.com?q=foo' }

  describe '#create' do
    let(:response) { xhr :post, :create, :url => url }

    it 'should be a 201' do
      expect(response.code).to eq('201')
    end

    it 'should create the site' do
      expect {
        response
      }.to change(Site, :count).by(1)
    end

    it 'should have the url' do
      response

      site = Site.latest
      expect(site.url).to eq('http://google.com?q=foo')
    end

    it 'should return the site' do
      json = JSON.parse(response.body)

      site = Site.latest
      expect(json['site']).to eq(JSON.parse(site.to_json))
    end

    describe 'when a site exists by url' do
      let!(:site) { create(:site, :url => url) }

      it 'should not create a site' do
        expect {
          response
        }.not_to change(Site, :count)
      end

      it 'should return the site' do
        json = JSON.parse(response.body)

        expect(json['site']).to eq(JSON.parse(site.to_json))
      end
    end
  end
end
