require File.join(File.dirname(__FILE__), 'spec_helper')
require 'drb_processing/client'
require 'drb_processing/server'

describe DRbProcessing::Client do
  
  before :each do
    @mock_app = Object.new
    @it = DRbProcessing::Client.new(@mock_app)
  end
  
  describe "#connect" do
    
    it "connects to a server" do
      server = DRbProcessing::Server.new 'druby://0.0.0.0:9000'
      server.start
      @it.connect 'druby://localhost:9000'
      server.should_receive(:oval).with(0, 0, 0, 0)
      @it.oval(0, 0, 0, 0)
      @it.disconnect
      server.stop
    end
    
    it "passes a Processing::App object to receive commands back from server" do
      server = DRbProcessing::Server.new 'druby://0.0.0.0:9000'
      server.start
      @it.connect 'druby://localhost:9000'
      @mock_app.should_receive(:oval).with(0, 0, 0, 0)
      @it.oval(0, 0, 0, 0)
      @it.disconnect
      server.stop
    end
    
  end
  
  describe "#disconnect" do
    it "removes Processing app from server" do
      server = DRbProcessing::Server.new 'druby://0.0.0.0:9000'
      server.start
      @it.connect 'druby://localhost:9000'
      @mock_app.should_receive(:oval).with(0, 0, 0, 0)
      @it.oval(0, 0, 0, 0)
      @it.disconnect
      @mock_app.should_not_receive(:oval)
      @it.oval(0, 0, 0, 0)
      server.stop
    end
    
    it "allows reconnection later" do
      server = DRbProcessing::Server.new 'druby://0.0.0.0:9000'
      server.start
      @it.connect 'druby://localhost:9000'
      @mock_app.should_receive(:oval).with(0, 0, 0, 0)
      @it.oval(0, 0, 0, 0)
      @it.disconnect
      @it.connect 'druby://localhost:9000'
      @mock_app.should_receive(:oval).with(0, 0, 0, 0)
      @it.oval(0, 0, 0, 0)
      server.stop
    end
  end
  
  describe "#app" do
    it "should not allow insecure methods like instance_eval"
  end
  
  it "should not allow insecure methods like instance_eval"
  
end