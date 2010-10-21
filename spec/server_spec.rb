require File.join(File.dirname(__FILE__), 'spec_helper')
require 'drb_processing/server'

describe DRbProcessing::Server do
  
  before :each do
    @it = DRbProcessing::Server.new
  end
  
  describe "#start" do
    
    it "serves a MethodTee object"
    it ""
    
  end
  
  describe "illegal methods" do
    it "should not allow dangerous methods like instance_eval"
  end
  
  
end