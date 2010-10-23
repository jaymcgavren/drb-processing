require File.join(File.dirname(__FILE__), 'spec_helper')
require 'drb_processing/server'

describe DRbProcessing::Server do
  
  before :each do
    @it = DRbProcessing::Server.new 'druby://0.0.0.0:9000'
  end
  
  describe "#start" do
    
    it "serves a MethodTee object"
    it ""
    
  end
  
  it "should not allow insecure methods like instance_eval" do
    @it.start
    @mock_app = Object.new
    client = DRbProcessing::Client.new(@mock_app)
    client.connect 'druby://0.0.0.0:9000'
    class <<client
      undef_method :instance_eval
    end
    lambda {puts client.instance_eval "puts self.class.name"}.should raise_error
  end
  
end

# %w{
#   clone
#   define_singleton_method
#   display
#   dup
#   extend
#   freeze
#   instance_eval
#   instance_exec
#   instance_variable_defined?
#   instance_variable_get
#   instance_variable_set
#   instance_variables
#   public_send
#   remove_instance_variable
#   send
#   tap
#   library_loaded?
#   load_java_library
#   load_libraries
#   load_library
#   load_ruby_library
# }.each do |method|
#   if method_defined?(method.to_sym)
#     undef_method(method.to_sym)
#   end
# end
