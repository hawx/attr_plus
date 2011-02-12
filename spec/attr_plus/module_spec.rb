require 'spec_helper'

describe Module do
  
  describe "#module_attr_reader" do
    subject { Module.new { module_attr_reader :test } }
    
    it "defines a read method for the module" do
      subject.should respond_to :test
    end
  end
  
  describe "#module_attr_writer" do
    subject { Module.new { module_attr_writer :test } }
    
    it "defines a write method for the module" do
      subject.should respond_to :test=
    end
  end
  
  describe "#module_attr_accessor" do
    subject { Module.new { module_attr_accessor :test } }
    
    it "defines a read method for the module" do
      subject.should respond_to :test
    end
    
    it "defines a write method for the module" do
      subject.should respond_to :test=
    end
  end
  
  context "When given a default value" do
    subject { Module.new { module_attr_accessor :test => "hi" } }
    
    it "returns the default value before being changed" do
      subject.test.should == "hi"
    end
    
    it "returns the new value if it is changed" do
      subject.test = nil
      subject.test.should be_nil
    end
    
    context "when this module is included" do
      subject { Class.new { include Module.new { module_attr_accessor :test => "hi" } } }
      
      it "returns the default value as well" do
        subject.test.should == "hi"
      end
    end
    
  end
  
end