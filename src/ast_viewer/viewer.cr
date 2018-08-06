class ASTViewer::Viewer
  property colorize : Bool = true
  getter node : Crystal::ASTNode

  def initialize(@node)
  end

  private def scan(io : IO, node : Crystal::Expressions, offset, kind = nil)
    output_node
    node.expressions.each do |ex|
      scan_for("expression", "ex")
    end
  end

  {% for node_type in %w(StringLiteral CharLiteral SymbolLiteral BoolLiteral) %}

  private def scan(io : IO, node : Crystal::{{node_type.id}}, offset, kind = nil)
    node_to_io(io, node, offset, kind, desc: node.value.inspect)
  end

  {% end %}

  private def scan(io : IO, node : Crystal::NumberLiteral, offset, kind = nil)
    node_to_io(io, node, offset, kind, desc: node.value + node.kind.to_s)
  end

  private def scan(io : IO, node : Crystal::StringInterpolation, offset, kind = nil)
    output_node
    node.expressions.each do |ex|
      scan_for("expression", "ex")
    end
  end

  private def scan(io : IO, node : Crystal::ArrayLiteral, offset, kind = nil)
    output_node
    node.elements.each do |elm|
      scan_for("element", "elm")
    end
    scan_if_has("of")
    scan_if_has("name")
  end

  private def scan(io : IO, node : Crystal::TupleLiteral, offset, kind = nil)
    output_node
    node.elements.each do |elm|
      scan_for("element", "elm")
    end
  end

  private def scan(io : IO, node : Crystal::HashLiteral, offset, kind = nil)
    output_node
    node.entries.each do |ent|
      scan_for("entry", "ent")
    end
    scan_if_has("of")
    scan_if_has("name")
  end

  private def scan(io : IO, node : Crystal::NamedTupleLiteral, offset, kind = nil)
    output_node
    node.entries.each do |ent|
      scan_for("entry", "ent")
    end
  end

  {% for node_type in %w(HashLiteral NamedTupleLiteral) %}

  private def scan(io : IO, node : Crystal::{{node_type.id}}::Entry, offset, kind = nil)
    output_node
    scan_for("key")
    scan_for("value")
  end

  {% end %}

  private def scan(io : IO, node : Crystal::RangeLiteral, offset, kind = nil)
    output_node
    scan_for("from")
    scan_for("to")
    scan_if_has?("exclusive")
  end

  private def scan(io : IO, node : Crystal::RegexLiteral, offset, kind = nil)
    output_node
    scan_for("value")
    scan_for("options")
  end

  private def scan(io : IO, node : Crystal::Var, offset, kind = nil)
    output_node("node.name")
  end

  private def scan(io : IO, node : Crystal::Block, offset, kind = nil)
    output_node
    scan_for("args")
    scan_for("body")
    scan_if_has("splat_index")
  end

  private def scan(io : IO, node : Crystal::Call, offset, kind = nil)
    output_node
    scan_if_has("obj")
    scan_for("name")
    scan_for("args")
    scan_if_has("block")
    scan_if_has("block_arg")
    scan_if_has("named_args")
  end

  private def scan(io : IO, node : Crystal::NamedArgument, offset, kind = nil)
    output_node
    scan_for("name")
    scan_for("value")
  end

  {% for node_type in %w(If Unless MacroIf) %}

  private def scan(io : IO, node : Crystal::{{node_type.id}}, offset, kind = nil)
    output_node
    scan_for("cond")
    scan_for("then")
    scan_for("else")
  end

  {% end %}

  private def scan(io : IO, node : Crystal::Assign, offset, kind = nil)
    output_node
    scan_for("target")
    scan_for("value")
  end

  private def scan(io : IO, node : Crystal::OpAssign, offset, kind = nil)
    output_node
    scan_for("target")
    scan_for("op")
    scan_for("value")
  end

  private def scan(io : IO, node : Crystal::MultiAssign, offset, kind = nil)
    output_node
    scan_for("targets")
    scan_for("values")
  end

  {% for node_type in %w(InstanceVar ClassVar Global AnnotationDef) %}

  private def scan(io : IO, node : Crystal::{{node_type.id}}, offset, kind = nil)
    output_node("node.name")
  end

  {% end %}

  private def scan(io : IO, node : Crystal::ReadInstanceVar, offset, kind = nil)
    output_node("node.name")
    scan_for("obj")
  end

  {% for node_type in %w(And Or) %}

  private def scan(io : IO, node : Crystal::{{node_type.id}}, offset, kind = nil)
    output_node
    scan_for("left")
    scan_for("right")
  end

  {% end %}

  private def scan(io : IO, node : Crystal::Arg, offset, kind = nil)
    output_node("node.name")
    scan_for("external_name") unless node.name == node.external_name
    scan_if_has("default_value")
    scan_if_has("restriction")
  end

  private def scan(io : IO, node : Crystal::ProcNotation, offset, kind = nil)
    output_node
    scan_for("inputs")
    scan_for("output")
  end

  private def scan(io : IO, node : Crystal::Def, offset, kind = nil)
    output_node("node.name")
    scan_if_has("free_vars")
    scan_if_has("receiver")
    scan_for("args")
    scan_if_has("double_splat")
    scan_for("body")
    scan_if_has("block_arg")
    scan_if_has("return_type")
    scan_if_has("splat_index")
    scan_for("visibility")
    scan_if_has?("macro_def")
    scan_if_has?("abstract")
  end

  private def scan(io : IO, node : Crystal::Macro, offset, kind = nil)
    output_node("node.name")
    scan_for("args")
    scan_if_has("double_splat")
    scan_for("body")
    scan_if_has("block_arg")
    scan_if_has("splat_index")
  end

  {% for node_type in %w(Not PointerOf SizeOf InstanceSizeOf Out MacroVerbatim) %}

  private def scan(io : IO, node : Crystal::{{node_type.id}}, offset, kind = nil)
    output_node
    scan_for("exp")
  end

  {% end %}

  private def scan(io : IO, node : Crystal::VisibilityModifier, offset, kind = nil)
    output_node("node.modifier")
    scan_for("exp")
  end

  private def scan(io : IO, node : Crystal::IsA, offset, kind = nil)
    output_node
    scan_for("obj")
    scan_for("const")
  end

  private def scan(io : IO, node : Crystal::RespondsTo, offset, kind = nil)
    output_node
    scan_for("obj")
    scan_for("name")
  end

  private def scan(io : IO, node : Crystal::Require, offset, kind = nil)
    output_node("node.string")
  end

  private def scan(io : IO, node : Crystal::When, offset, kind = nil)
    output_node
    scan_for("conds")
    scan_for("body")
  end

  private def scan(io : IO, node : Crystal::Case, offset, kind = nil)
    output_node
    scan_for("cond")
    scan_for("whens")
    scan_for("else")
  end

  private def scan(io : IO, node : Crystal::Select, offset, kind = nil)
    output_node
    scan_for("whens")
    scan_for("else")
  end

  private def scan(io : IO, node : Crystal::Select::When, offset, kind = nil)
    output_node
    scan_for("condition")
    scan_for("body")
  end

  private def scan(io : IO, node : Crystal::Path, offset, kind = nil)
    output_node("node.names.join(\"::\")")
    scan_if_has?("global")
    scan_for("visibility")
  end

  private def scan(io : IO, node : Crystal::ClassDef, offset, kind = nil)
    output_node
    scan_for("name")
    scan_for("body")
    scan_if_has("superclass")
    scan_if_has("type_vars")
    scan_if_has("splat_index")
    scan_if_has?("abstract")
    scan_if_has?("struct")
    scan_for("visibility")
  end

  private def scan(io : IO, node : Crystal::ModuleDef, offset, kind = nil)
    output_node
    scan_for("name")
    scan_for("body")
    scan_if_has("type_vars")
    scan_if_has("splat_index")
    scan_for("visibility")
  end

  {% for node_type in %w(While Until) %}

  private def scan(io : IO, node : Crystal::{{node_type.id}}, offset, kind = nil)
    output_node
    scan_for("cond")
    scan_for("body")
  end

  {% end %}

  private def scan(io : IO, node : Crystal::Generic, offset, kind = nil)
    output_node
    scan_for("name")
    scan_for("type_vars")
    scan_if_has("named_args")
  end

  private def scan(io : IO, node : Crystal::TypeDeclaration, offset, kind = nil)
    output_node
    scan_for("var")
    scan_for("declared_type")
    scan_if_has("value")
  end

  private def scan(io : IO, node : Crystal::UninitializedVar, offset, kind = nil)
    output_node
    scan_for("var")
    scan_for("declared_type")
  end

  private def scan(io : IO, node : Crystal::Rescue, offset, kind = nil)
    output_node
    scan_for("body")
    scan_if_has("types")
    scan_if_has("name")
  end

  private def scan(io : IO, node : Crystal::ExceptionHandler, offset, kind = nil)
    output_node
    scan_for("body")
    scan_if_has("rescues")
    scan_if_has("else")
    scan_if_has("ensure")
    scan_for("implicit")
    scan_for("suffix")
  end

  private def scan(io : IO, node : Crystal::ProcLiteral, offset, kind = nil)
    output_node
    scan_for("def")
  end

  private def scan(io : IO, node : Crystal::ProcPointer, offset, kind = nil)
    output_node("node.name")
    scan_if_has("obj")
    scan_for("args")
  end

  private def scan(io : IO, node : Crystal::Union, offset, kind = nil)
    output_node
    scan_for("types")
  end

  {% for node_type in %w(Return Next Break) %}

  private def scan(io : IO, node : Crystal::{{node_type.id}}, offset, kind = nil)
    output_node
    scan_if_has("exp")
  end

  {% end %}

  private def scan(io : IO, node : Crystal::Yield, offset, kind = nil)
    output_node
    scan_for("exps")
    scan_if_has("scope")
  end

  {% for node_type in %w(Include Extend Metaclass) %}

  private def scan(io : IO, node : Crystal::{{node_type.id}}, offset, kind = nil)
    output_node
    scan_for("name")
  end

  {% end %}

  private def scan(io : IO, node : Crystal::LibDef, offset, kind = nil)
    output_node("node.name")
    scan_for("body")
    scan_for("visibility")
  end

  private def scan(io : IO, node : Crystal::FunDef, offset, kind = nil)
    output_node("node.name")
    scan_for("args")
    scan_if_has("body")
    scan_if_has("return_type")
    scan_for("real_name") unless node.name == node.real_name
    scan_for("visibility")
    scan_if_has?("varargs")
  end

  private def scan(io : IO, node : Crystal::TypeDef, offset, kind = nil)
    output_node("node.name")
    scan_for("type_spec")
  end

  private def scan(io : IO, node : Crystal::CStructOrUnionDef, offset, kind = nil)
    output_node("node.name")
    scan_for("body")
    scan_if_has?("union")
  end

  private def scan(io : IO, node : Crystal::EnumDef, offset, kind = nil)
    output_node
    scan_for("name")
    scan_for("members")
    scan_if_has("base_type")
    scan_for("visibility")
  end

  private def scan(io : IO, node : Crystal::ExternalVar, offset, kind = nil)
    output_node("node.name")
    scan_for("type_spec")
    scan_if_has("real_name")
  end

  private def scan(io : IO, node : Crystal::Alias, offset, kind = nil)
    output_node
    scan_for("name")
    scan_for("value")
    scan_for("visibility")
  end

  {% for node_type in %w(Cast NilableCast) %}

  private def scan(io : IO, node : Crystal::{{node_type.id}}, offset, kind = nil)
    output_node
    scan_for("obj")
    scan_for("to")
  end

  {% end %}

  private def scan(io : IO, node : Crystal::TypeOf, offset, kind = nil)
    output_node
    scan_for("expressions")
  end

  private def scan(io : IO, node : Crystal::Annotation, offset, kind = nil)
    output_node
    scan_for("path")
    scan_for("args")
    scan_if_has("named_args")
  end

  private def scan(io : IO, node : Crystal::MacroExpression, offset, kind = nil)
    output_node
    scan_for("exp")
    scan_if_has?("output")
  end

  private def scan(io : IO, node : Crystal::MacroLiteral, offset, kind = nil)
    output_node("node.value")
  end

  private def scan(io : IO, node : Crystal::MacroFor, offset, kind = nil)
    output_node
    scan_for("vars")
    scan_for("exp")
    scan_for("body")
  end

  private def scan(io : IO, node : Crystal::MacroVar, offset, kind = nil)
    output_node("node.name")
    scan_if_has("exps")
  end

  private def scan(io : IO, node : Crystal::MagicConstant, offset, kind = nil)
    output_node("node.name.to_s")
  end

  private def scan(io : IO, node : Crystal::Asm, offset, kind = nil)
    output_node
    scan_for("text")
    scan_if_has("output")
    scan_if_has("inputs")
    scan_if_has("clobbers")
    scan_if_has?("volatile")
    scan_if_has?("alignstack")
    scan_if_has?("intel")
  end

  private def scan(io : IO, node : Crystal::AsmOperand, offset, kind = nil)
    output_node
    scan_for("constraint")
    scan_for("exp")
  end

  # Nop, ImplicitObj, Self, Underscore, Splat, DoubleSplat
  private def scan(io : IO, node : Crystal::ASTNode, offset, kind = nil)
    output_node
  end

  private def scan(io : IO, node : Array, offset, kind = nil)
    unless node.empty?
      output_node
      node.each do |item|
        scan_for("element", "item")
      end
    end
  end

  private def scan(io : IO, node, offset, kind = nil)
    node_to_io(io, node, offset, kind, desc: node.inspect)
  end

  private def node_to_io(io : IO, node, offset, kind = nil, *, desc = nil)
    colorize = if @colorize && io.is_a?(IO::FileDescriptor)
                 io.tty?
               else
                 false
               end
    if offset > 0
      (offset - 1).times do
        io << "  "
      end
      io << "->"
    end
    if kind
      io << (colorize ? kind.colorize(:light_magenta) : kind)
      io << ": "
    end
    io << (colorize ? node.class.to_s.colorize(:blue) : node.class)
    if desc
      io << '('
      io << (colorize ? desc.colorize(:light_green) : desc)
      io << ')'
    end
    io << '\n'
    offset + 1
  end

  def to_s(io : IO)
    scan(io, @node, 0)
  end

  private macro output_node(desc = nil)
    offset = node_to_io(io, node, offset, kind, desc: {{desc.id}})
  end

  private macro scan_for(name)
    scan(io, node.{{name.id}}, offset, {{name}})
  end

  private macro scan_for(name, taeget)
    scan(io, {{taeget.id}}, offset, {{name}})
  end

  private macro scan_if_has(name)
    if propaty_{{name.id}} = node.{{name.id}}
      scan(io, propaty_{{name.id}}, offset, {{name}})
    end
  end

  private macro scan_if_has?(name)
    if propaty_{{name.id}} = node.{{name.id}}?
      scan(io, propaty_{{name.id}}, offset, {{name}})
    end
  end
end
