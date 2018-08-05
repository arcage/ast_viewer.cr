require "compiler/crystal/syntax"
require "colorize"
require "./ast_viewer/*"

module ASTViewer
  def self.from_file(filename : String)
    source = File.read(filename)
    from_source(source)
  end

  def self.from_source(source : String)
    node = Crystal::Parser.parse(source)
    from_node(node)
  rescue ex : Crystal::SyntaxException
    ex.to_s_with_source(source, STDERR)
    exit(1)
  end

  def self.from_node(node : Crystal::ASTNode)
    Viewer.new(node)
  end
end
