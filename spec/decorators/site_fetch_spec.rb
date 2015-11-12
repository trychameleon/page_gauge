require 'spec_helper'

describe SiteFetch do
  let(:site) { build(:site, :url => 'http://foo.bar/foo') }

  let(:body) { '<html><head></head><body>Hello</body></html>' }
  let(:headers) { "Content-Type: text/html\nContent-Length: 3" }
  let(:response) { Typhoeus::Response.new(:response_code => 200, :body => body, :response_headers => headers, :total_time => 0.245, :redirect_count => 5) }

  let!(:request) { instance_double(Typhoeus::Request, :run => response, :marshal_dump => ['Marshaled content']) }

  describe '.run' do
    let(:run) { site.save }

    before do
      allow(Typhoeus::Request).to receive(:new).and_return(request)
    end

    it 'should request the url' do
      expect(Typhoeus::Request).to receive(:new).with('http://foo.bar/foo', anything).and_return(request)

      run
    end

    it 'should request GET' do
      expect(Typhoeus::Request).to receive(:new).with(anything, hash_including(method: :get)).and_return(request)

      run
    end

    it 'should follow redirects' do
      expect(Typhoeus::Request).to receive(:new).with(anything, hash_including(followlocation: true)).and_return(request)

      run
    end

    it 'should accept gzip' do
      expect(Typhoeus::Request).to receive(:new).with(anything, hash_including(accept_encoding: 'gzip')).and_return(request)

      run
    end

    it 'should make the request' do
      expect(request).to receive(:run).and_return(response)

      run
    end

    it 'should add the code' do
      run

      expect(site.code).to eq('200')
    end

    it 'should add the headers' do
      run

      expect(site.headers).to eq(headers)
    end

    it 'should add the body' do
      run

      expect(site.body).to eq(body)
    end

    it 'should add the time' do
      run

      expect(site.duration).to eq(0.245)
    end

    it 'should add the redirect count' do
      run

      expect(site.redirect_count).to eq('5')
    end

    it 'should have the raw response' do
      run

      expect(site.marshaled_request).to eq(['Marshaled content'])
    end
  end
end
