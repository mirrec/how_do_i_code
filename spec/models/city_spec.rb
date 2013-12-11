require 'spec_helper'

describe City do
  describe "validation" do
    it "validates presents of mandatory attributes" do
      s = City.new
      s.should_not be_valid
      s.should have(1).error_on(:name)
    end
  end
end
