class Email
  def self.identify(user)
    traits = user.slice(:created_at, :email)

    client.identify(:user_id => user.id, :traits => traits)
  end

  def self.ping(user, event, options={})
    identify(user)

    client.track(
      :user_id => user.id,
      :event => event,
      :properties => options
    )
  end

  private

  def self.client
    Thread.current[:segment] ||= Segment::Analytics.new(:write_key => ENV['SEGMENT_KEY'])
  end

  def self.urls
    Rails.application.routes.url_helpers
  end
end
