require 'spec_helper'

describe AttrPlus do

  describe "#separate_argument_list_and_default" do
    def call_it(*args)
      AttrPlus.separate_arguments(*args)
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