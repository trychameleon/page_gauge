Dir[Rails.root.join('app/controllers/**/*.rb')].each {|f| require f }

BasicObject.const_set('ApplicationController', Application)
