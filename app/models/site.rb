class Site < Model
  attrs String => { :url => :u, :code => :c, :headers => :h, :body => :b, :redirect_count => :rc },
    Float => { :duration => :d },
    Hash => { :raw => :r }

  validates :url, :presence => true

  allow *mongo_fields.values.map(&:keys).flatten

  before_create -> { SiteFetch.new(self).run }

end
