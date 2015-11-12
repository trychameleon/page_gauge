class SiteStats < Worker
  def perform(site_id)
    count = Sidekiq.redis {|r| r.incr('sites:count') }

    Hookly::Message.create('#stats', sites: { count: count })
  end
end
