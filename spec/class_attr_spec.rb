require 'spec_helper'

describe Object do

  describe "#class_attr_reader" do
    subject { Class.new { class_attr_reader :test } }
  
    it "defines a read method for the class" do 
      subject.should respond_to :test
    end
    
    it "defines a read method for instances of the class" do
      subject.new.should respond_to :test
    end
  end
  
  describe "#class_attr_writer" do
    subject { Class.new { class_attr_writer :test } }
  
    it "defines a write method for the class" do
      subject.should respond_to :test=
    end
  end
  
  describe "#class_attr_accessor" do
    subject { Class.new { class_attr_accessor :test } }
  
    it "defines a read method for the class" do
      subject.should respond_to :test
    end
    
    it "defines a write method for the class" do
      subject.should respond_to :test=
    end
    
    it "defines a read method for instances of the class" do
      subject.new.should respond_to :test
    end
  end
  
  # The subclass thing was starting to annoy me...
  context "When there is a subclass of a class with class_attrs" do

    let(:sup) { Class.new { class_attr_accessor :test } }
    let(:sub) { Class.new(sup) }

    it "has the methods of the superclass" do
      sub.should respond_to :test
      sub.should respond_to :test=
    end
    
    describe "calling the writer method on the subclass" do
      it "should not alter the value on the superclass" do
        sub.test = "changed"
        sub.test.should == "changed"
        sup.test.should_not == "changed"
      end
    end
    
    describe "calling the writer method on the superclass" do
      it "should not alter the value on the subclass" do
        sup.test = "changed again"
        sup.test.should == "changed again"
        sub.test.should_not == "changed again"
      end
    end
  end
    
    
  # Inheritable class attributes
  
  describe "#inheritable_class_attr_reader" do
    subject { Class.new { inheritable_class_attr_reader :test } }
    
    it "defines a read method for the class" do
      subject.should respond_to :test
    end
    
    it "defines a read method for instances of the class" do
      subject.new.should respond_to :test
    end
  end
  
  describe "#inheritable_class_attr_writer" do
    subject { Class.new { inheritable_class_attr_writer :test } }
    
    it "defines a write method for the class" do
      subject.should respond_to :test=
    end
  end
  
  describe "#inheritable_class_attr_accessor" do
    subject { Class.new { inheritable_class_attr_accessor :test } }
  
    it "defines a read method for the class" do
      subject.should respond_to :test
    end
    
    it "defines a write method for the class" do
      subject.should respond_to :test=
    end
    
    it "defines a read method for instances of the class" do
      subject.new.should respond_to :test
    end
  end
  
  context "When there is a subclass of a class with inheritable_class_attrs" do
  
    let(:sup) { Class.new { inheritable_class_attr_accessor :test } }
    let(:sub) { Class.new(sup) }

    it "has the methods of the superclass" do
      sub.should respond_to :test
      sub.should respond_to :test=
    end
    
    describe "calling the writer method on the subclass" do
      it "should not alter the value on the superclass" do
        sub.test = "changed"
        sub.test.should == "changed"
        sup.test.should_not == "changed"
      end
    end
    
    describe "calling the writer method on the superclass" do
      it "should alter the value on the subclass if not set" do
        sup.test = "changed it"
        sup.test.should == "changed it"
        sub.test.should == "changed it"
      end
      
      it "should not alter the value on the subclass if set" do
        sub.test = "already set"
        sup.test = "change it"
        sup.test.should == "change it"
        sub.test.should == "already set"
      end
    end
  end
  
  
  describe "#separate_argument_list_and_default" do
    def call_it(*args)
      Class.send(:separate_argument_list_and_default, *args)
    end
    
    context "when given a list of arguments with a default" do
      it "returns an array with the arguments and a default value" do
        call_it([:one, :two, :three, {:default => 0}]).should == [[:one, :two, :three], 0]
      end
    end
    
    context "when given an argument and a default" do
      it "returns an array with the arguments and a default value" do
        call_it([{:one => 1}]).should == [[:one], 1]
      end
    end
    
    context "when given just arguments" do
      it "returns and array with the arguments and nil" do
        call_it([:one, :two, :three]).should == [[:one, :two, :three], nil]
      end
    end
  end

end