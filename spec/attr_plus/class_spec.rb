require 'spec_helper'

describe Class do

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
  
  context "When given a default value" do
    
    subject { Class.new { class_attr_accessor :test => "hi" } }
    
    it "returns the default value before it is changed" do
      subject.test.should == "hi"
    end
    
    it "returns the new value if it is changed" do
      subject.test = nil
      subject.test.should be_nil
    end
    
    context "When this class is inherited" do
      let(:sub) { Class.new(subject) }
      
      it "returns the default value as well" do
        sub.test.should == "hi"
      end
    end
    
  end
  
end