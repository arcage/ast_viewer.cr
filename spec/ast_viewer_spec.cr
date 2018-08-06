require "./spec_helper"

describe ASTViewer do

  it "works with NumberLiteral" do
    ASTViewer.from_source("1").to_s.should eq "Crystal::NumberLiteral(1i32)\n"
  end

  it "works with StringLiteral" do
    ASTViewer.from_source("\"s\"").to_s.should eq "Crystal::StringLiteral(\"s\")\n"
  end

  it "works with CharLiteral" do
    ASTViewer.from_source("'c'").to_s.should eq "Crystal::CharLiteral('c')\n"
  end

end
