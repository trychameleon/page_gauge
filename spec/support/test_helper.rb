module TestHelper
  def self.included(base)
    base.send(:include, InstanceMethods)
  end

  module InstanceMethods
  end

end
