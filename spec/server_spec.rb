require File.join(File.dirname(__FILE__), 'spec_helper')
require 'drb-processing/server'

describe DRbProcessing::Server do
  
  before :each do
    @it = DRbProcessing::Server.new 'localhost', 9000
  end
  
  it "should not allow insecure methods like instance_eval" do
    @it.start
    @mock_app = Object.new
    client = DRbProcessing::Client.new(@mock_app)
    client.connect 'localhost', 9000
    class <<client
      undef_method :instance_eval
    end
    result = client.instance_eval('"unsafe code running in #{self.class.name}"')
    result.should be_nil
    @it.stop
  end
  
  it "allows reconnection later" do
    @it.start
    @it.logger = Logger.new(STDOUT)
    mock_app1 = Object.new
    client1 = DRbProcessing::Client.new(mock_app1)
    client1.logger = Logger.new(STDOUT)
    client1.connect 'localhost', 9000
    mock_app1.should_receive(:oval).with(0, 0, 0, 0)
    client1.oval(0, 0, 0, 0)
    client1.disconnect
    client1.connect 'localhost', 9000
    mock_app1.should_receive(:rect).with(0, 0, 10, 10)
    client1.rect(0, 0, 10, 10)
    @it.stop
  end
  
  it "disconnects a client if they appear to have dropped"
  
  it "continues serving other clients if a client is dropped"
  
  it "maintains connection even if a method call throws an exception"
  
  it "rejects clients not approved by ACL"
  
  it "can reload ACL from disk on demand"
  
end
