require 'spec_helper'

describe "Hash" do
  
  describe '.hash_attr_reader' do
    subject {
      Class.new {
        hash_attr_reader :@config, :name
        def initialize
          @config = {:name => "John Doe"}
        end
      }.new
    }
    
    it "creates the reader method" do
      subject.should respond_to :name
    end
    
    it "gets the value from the correct hash" do
      subject.name.should == "John Doe"
    end
  end
  
  describe '.hash_attr_writer' do
    subject {
      Class.new {
        attr_reader :config
        hash_attr_writer :@config, :name
        def initialize
          @config = {}
        end
      }.new
    }
    
    it "creates the writer method" do
      subject.should respond_to :name=
    end
    
    it "sets the value in the hash" do
      subject.name = "John Doe"
      subject.config[:name].should == "John Doe"
    end
  end
  
  
  describe '.hash_attr_accessor' do
    subject {
      Class.new {
        attr_reader :config
        hash_attr_accessor :@config, :name, :age
        def initialize
          @config = {
            :name => 'John Doe',
            :age  => 21
          }
        end
      }.new
    }
    
    it "creates the methods" do
      subject.should respond_to :name
      subject.should respond_to :age
      subject.should respond_to :name=
      subject.should respond_to :age=
    end
    
    it "allows you to read values" do
      subject.name.should == 'John Doe'
      subject.age.should == 21
    end
    
    it "allows you to set values" do
      subject.name = 'Dave Jones'
      subject.age = 59
      subject.config.should == {:name => 'Dave Jones', :age => 59}
    end
  end
  
  
  describe '.class_hash_attr_reader' do
    subject {
      Class.new {
        @config = {:name => 'John Doe'}
        class_hash_attr_reader :@config, :name
      }
    }
    
    it "creates the reader method" do
      subject.should respond_to :name
    end
    
    it "gets the value from the correct hash" do
      subject.name.should == "John Doe"
    end
  end
  
  describe '.class_hash_attr_writer' do
    subject {
      Class.new {
        @config = {}
        class_hash_attr_writer :@config, :name
        class << self; attr_accessor :config; end
      }
    }
    
    it "creates the writer method" do
      subject.should respond_to :name=
    end
    
    it "sets the value in the hash" do
      subject.name = "John Doe"
      subject.config[:name].should == "John Doe"
    end
  end
  
  describe '.hash_attr_accessor' do
    subject {
      Class.new {
        class << self; attr_reader :config; end
        class_hash_attr_accessor :@config, :name, :age
        @config = {
          :name => 'John Doe',
          :age  => 21
        }
      }
    }
    
    it "creates the methods" do
      subject.should respond_to :name
      subject.should respond_to :age
      subject.should respond_to :name=
      subject.should respond_to :age=
    end
    
    it "allows you to read values" do
      subject.name.should == 'John Doe'
      subject.age.should == 21
    end
    
    it "allows you to set values" do
      subject.name = 'Dave Jones'
      subject.age = 59
      subject.config.should == {:name => 'Dave Jones', :age => 59}
    end
  end
  
end