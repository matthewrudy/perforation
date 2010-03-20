require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/class/inheritable_attributes' # for class_inheritable_accessor
require 'mechanize'
require 'uri'

module Perforation
end
require 'perforation/actor'
require 'perforation/runner'
require 'perforation/performer'