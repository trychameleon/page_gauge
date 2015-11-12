require 'rubygems'
require 'bundler'
Bundler.setup

require ::File.expand_path('../config/environment',  __FILE__)

run Rails.application
