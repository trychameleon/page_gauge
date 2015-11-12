class Site < Model
  attrs String => { :url => :u, :code => :c, :headers => :h, :body => :b, :redirect_count => :rc },
    Float => { :duration => :d },
    Hash => { :raw => :r }

  validates :url, :presence => true

  allow :url
  allow_json *mongo_fields.values.map(&:keys).flatten

  indexed :url, :uniq => true

  before_create -> { SiteFetch.new(self).run }
  after_create  -> { SiteStats.perform_async(id) }

  def url=(other)
    other = (other.presence || '').downcase
    other = "http://#{other}" unless other.blank? || /https?:\/\// === other

    self[:url] = other
  end
end
