require 'spec_helper'

describe Module do

  describe ".private_attr_reader" do
    subject { 
      Class.new { 
        private_attr_reader :test
        attr_writer :test
        def read; test; end
      }.new 
    }
    
    it "defines a private reader method" do
      subject.should_not respond_to :test
      subject.respond_to?(:test, true).should be_true
    end
    
    it "allows the class to call it" do
      subject.test = "hi"
      subject.instance_eval("test").should == "hi"
    end
  end
  
  describe ".private_attr_writer" do
    subject { 
      Class.new { 
        private_attr_writer :test
        attr_reader :test
      }.new
    }
    
    it "defines a private reader method" do
      subject.should_not respond_to :test=
      subject.respond_to?(:test=, true).should be_true
    end
    
    it "allows the class to call it" do
      subject.instance_eval("self.test = 'hi'")
      subject.test.should == "hi"
    end
  end
  
  describe ".private_attr_accessor" do
    subject {
      Class.new {
        private_attr_accessor :test
        def read; test; end
      }.new
    }
    
    it "defines private writer and reader methods" do
      subject.should_not respond_to :test
      subject.respond_to?(:test, true).should be_true
      
      subject.should_not respond_to :test=
      subject.respond_to?(:test=, true).should be_true
    end
    
    it "allows the class to write to it" do
      subject.instance_eval("self.test = 'hi'")
      subject.read.should == "hi"
    end
    
    it "allows the class to read it" do
      subject.send(:test=, "hi")
      subject.instance_eval("test").should == "hi"
    end
  end
  
end