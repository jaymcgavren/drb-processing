require File.join(File.dirname(__FILE__), 'spec_helper')
require 'drb_processing/server'

describe DRbProcessing::Server do
  
  before :each do
    @it = DRbProcessing::Server.new 'druby://0.0.0.0:9000'
  end
  
  it "should not allow insecure methods like instance_eval" do
    @it.start
    @mock_app = Object.new
    client = DRbProcessing::Client.new(@mock_app)
    client.connect 'druby://0.0.0.0:9000'
    class <<client
      undef_method :instance_eval
    end
    result = client.instance_eval('"unsafe code running in #{self.class.name}"')
    result.should be_nil
  end
  
end
