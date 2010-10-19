require File.join(File.dirname(__FILE__), 'spec_helper')
require 'drb_processing/method_tee'

describe MethodTee do
  
  before :each do
    @it = MethodTee.new
  end
  
  describe "#add_method_tee" do
    
    it "copies method calls to multiple objects" do
      object1 = Object.new
      @it.add_method_tee object1
      object2 = Object.new
      @it.add_method_tee object2
      object1.should_receive(:foo).twice
      object2.should_receive(:foo).twice
      @it.foo
      @it.foo
    end
    
    it "includes arguments" do
      object1 = Object.new
      @it.add_method_tee object1
      object2 = Object.new
      @it.add_method_tee object2
      object1.should_receive(:foo).with('a', 'b')
      object2.should_receive(:foo).with('a', 'b')
      @it.foo('a', 'b')
    end
    
    it "sends calls to a single object if only one is assigned" do
      object1 = Object.new
      @it.add_method_tee object1
      object1.should_receive(:foo).with('a', 'b')
      @it.foo('a', 'b')
    end
    
    it "does not throw exception if no objects are assigned" do
      @it.foo('a', 'b')
    end
  
  end
  
  describe "#halt_on_exception" do
    
    it "halts on first failure when true" do
      @it.halt_on_exception = true
      object1 = Object.new
      @it.add_method_tee object1
      object2 = Object.new
      @it.add_method_tee object2
      object1.should_receive(:foo).and_raise(RuntimeError)
      object2.should_not_receive(:foo)
      lambda{@it.foo}.should raise_error
    end
    
    it "continues making method calls if one fails when false" do
      @it.halt_on_exception = false
      object1 = Object.new
      @it.add_method_tee object1
      object2 = Object.new
      @it.add_method_tee object2
      object1.should_receive(:foo).and_raise(RuntimeError)
      object2.should_receive(:foo)
      lambda{@it.foo}.should raise_error
    end
    
    it "includes a hash of objects called and the exceptions or return values they got"
    
    it "is true by default"
    
  end
  
  describe "#use_first_return_value" do
    it "returns the first return value when true"
    it "returns an array of all return values when false"
    it "is true by default"
  end
  
  
end