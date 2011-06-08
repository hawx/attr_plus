require 'spec_helper'

describe "Class" do

  describe ".class_attr_reader" do
    subject { Class.new { class_attr_reader :test } }
  
    it "defines a read method for the class" do 
      subject.should respond_to :test
    end
    
    it "defines a read method for instances of the class" do
      subject.new.should respond_to :test
    end
  end
  
  describe ".class_attr_writer" do
    subject { Class.new { class_attr_writer :test } }
  
    it "defines a write method for the class" do
      subject.should respond_to :test=
    end
    
    it "defines a write method for instances of the class" do
      subject.new.should respond_to :test=
    end
  end
  
  describe ".class_attr_accessor" do
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
    
    it "defines a write method for instances of the class" do
      subject.new.should respond_to :test=
    end
  end
  
  
# EDGE CASES, specifically where I've had issues in the past so need to check against
  
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
  
  
  context "When there are multiple instances of a class with class_attrs" do
  
    subject { Class.new { class_attr_accessor :attrs } }
    let(:obj1) { subject.new }
    let(:obj2) { subject.new }
  
    describe "the class" do
      it "should not be affected by changes to the objects" do
        subject.attrs = %w(coolness)
        obj1.attrs = %w(height weight)
        obj2.attrs = %w(volume density)
        subject.attrs.should == %w(coolness)
      end
      
      it "should not affect objects when they have been changed" do
        obj1.attrs = %w(name)
        obj2.attrs = %w(date)
        subject.attrs = %w(mass)
        obj1.attrs.should == %w(name)
        obj2.attrs.should == %w(date)
      end
      
      it "should affect objects when they have not been changed" do
        obj1.attrs = %w(hp)
        subject.attrs = %w(mp)
        obj1.attrs.should == %w(hp)
        obj2.attrs.should == %w(mp)
      end
    end
  
  end

end