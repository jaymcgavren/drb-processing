$: << File.expand_path(File.dirname(__FILE__))
$: << File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$: << File.expand_path(File.join(File.dirname(__FILE__), '..', 'vendor', 'drbfire', 'lib'))
require 'rubygems'
require 'spec'
require 'spec/autorun'

#Allowed margin of error for be_close.
MARGIN = 0.01

Spec::Runner.configure do |config|
  
end
