require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib/dust_tactics'))

require 'dust_tactics'
include DustTactics

# The problem with doing it this way is the load order
# For example, class A needs class B in order to work, but
# class A is loaded first
#Dir["./lib/**/*.rb"].each do |f| 
#  puts "loading #{f}"
#  load f
#end
