class Site < Model
  attrs String => { :uid => :i, :url => :u, :code => :c, :headers => :h, :body => :b, :marshaled_request => :mr },
    Float => { :duration => :d },
    Integer => { :redirect_count => :rc }

  validates :url, :presence => true

  allow :uid, :url
  allow_json *mongo_fields.values.map(&:keys).flatten - %i(marshaled_request)

  indexed :url, :uniq => true

  before_create -> { SiteFetch.new(self).run }
  # after_create  -> { SiteStats.perform_async(id) } TODO Re-enable for the top-level site when stats are enabled (in the pagegauge.io front-end)

  def url=(other)
    other = other.presence || ''
    other = "http://#{other}" unless other.blank? || /https?:\/\// === other

    self[:url] = other
  end
end
