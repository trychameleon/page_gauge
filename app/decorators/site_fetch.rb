class SiteFetch
  attr_reader :site

  def initialize(site)
    @site = site
  end

  def run
    request = Typhoeus::Request.new(site.url, :method => :get, :followlocation => true, :accept_encoding => 'gzip')
    response = request.run

    site.code = response.code.to_s
    site.duration = response.total_time
    site.headers = response.response_headers
    site.redirect_count = response.redirect_count.to_s
    site.body = response.body
    site.raw = JSON.parse(response.options.to_json)
  end
end
