PERFORATION_ROOT = File.expand_path(File.dirname(__FILE__))

$LOAD_PATH.unshift File.join(PERFORATION_ROOT,"lib")

require "#{File.dirname(__FILE__)}/vendor/gems/environment"
require "perforation"