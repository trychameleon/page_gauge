class Worker
  def self.inherited(base)
    base.send(:include, Sidekiq::Worker)
  end

  # InstanceMethods

  # ClassMethods
  def self.worker(options)
    sidekiq_options options
  end
end
