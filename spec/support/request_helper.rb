module RequestHelper
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.send(:extend, ClassMethods)
  end

  module InstanceMethods

  end

  module ClassMethods

  end
end
