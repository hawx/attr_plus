require 'spec_helper'

describe "Using a class level instance hash to hold config" do

  subject {
    Class.new {
      @config = {:name => 'SomeApp', :version => '3.1.7'}
      def self.config; @config; end
      class_hash_attr_accessor :config, :name, :version
    }
  }
  
  it "should get the values" do
    subject.config.should == {:name => 'SomeApp', :version => '3.1.7'}
    subject.name.should == 'SomeApp'
    subject.version.should == '3.1.7'
  end

end

describe "Using an instance level hash to hold config" do

  subject { 
    Class.new {
      def initialize; @config = {}; end
      attr_accessor :config
      hash_attr_accessor :config, :name, :version
    }.new
  }
  
  it "should get the values" do
    subject.name = 'SomeApp'
    subject.version = '1.5.0'
    subject.config.should == {:name => 'SomeApp', :version => '1.5.0'}
  end

end


describe "Putting things in a box" do

  subject {
    Class.new {
      attr_writer :stuff
      private_attr_reader :stuff
      
      def initialize
        @stuff = []
      end
      
      def <<(val)
        stuff << val
      end
      
      def shake
        stuff[rand(stuff.size)]
      end
    }.new
  }
  
  it "should work" do
    subject << "giraffe"
    subject << "elephant"
    subject << "camel"
    subject << "cat"
    %w(giraffe elephant camel cat).should include subject.shake
    expect { subject.stuff }.to raise_error NoMethodError
    subject.stuff = %w(dog hamster fish)
    %w(dog hamster fish).should include subject.shake
  end

end


describe "Storing lists of attributes for a class" do
  
  before {
    @file = Class.new {
      inheritable_class_attr_accessor :keys => []
      def self.attr(*attrs)
        keys.concat attrs
      end 
      attr :url, :permalink, :path, :content
    }
    
    @page = Class.new(@file) { attr :title }
    @post = Class.new(@page) { attr :date, :tags }
  }
  
  it "should work" do
    @file.keys.should == [:url, :permalink, :path, :content]
    @page.keys.should == [:url, :permalink, :path, :content, :title]
    @post.keys.should == [:url, :permalink, :path, :content, :title, :date, :tags]
  end
end


describe "A set of polygons" do

  before {
    @polygon = Class.new { 
      class_attr_writer :sides
      def self.triangle?; @sides == 3; end
      def self.rectangle?; @sides == 4; end
      def self.pentagon?; @sides == 5; end
      def self.nothing?; @sides.nil?; end
    }
    
    @triangle = Class.new(@polygon) { @sides = 3 }
    @rectangle = Class.new(@polygon) { @sides = 4 }
    @pentagon = Class.new(@polygon) { @sides = 5 }
  }
  
  it "should work" do
    @triangle.should be_a_triangle
    @rectangle.should be_a_rectangle
    @pentagon.should be_a_pentagon
    @polygon.should be_nothing
  end

end