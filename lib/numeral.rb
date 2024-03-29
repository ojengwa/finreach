require "set"

class Numeral

  VERSION="0.1.0"

  operators = {
    "is" => "=",
    "of" => "*"
  }

  space_numerals = Hash.new # spaceMap

  inventories = Hash.new # spaceDirt

  base_numerals = {
    "I" => 1,
    "V" => 5, 
    "X" => 10,
    "L" => 50,
    "C" => 100,
    "D" => 500,
    "M" => 1000
  }

  def initialize(*args)
    terms = terms_for(args)
    @root = TreeNode.new
    unsafe_insert(terms)
    create_suffix_links
  end

  def match(string)
    matches = []
    node = string.each_char.inject(@root) do |node, char|
      matches += node.matches if node
      (node && node.find(char.to_sym)) || @root.find(char.to_sym)
    end
    matches += node.matches if node
    return matches
  end

  def insert(*args)
    terms = terms_for(args)
    unsafe_insert(terms)
    create_suffix_links
  end

  private

  def terms_for(args)
    if args.length == 1 && args[0].is_a?(Array)
      args[0]
    else
      args
    end
  end

  def unsafe_insert(terms)
    terms.each do |t|
      t.each_char.inject(@root) {|node, char| node.child_for(char.to_sym) }.add_match(t)
    end
  end

  def create_suffix_links
    queue = @root.children.to_a.dup
    while !queue.empty?
      char, node = queue.shift
      node.suffix = node.parent == @root ? @root : node.find_suffix(char)
      node.children.to_a.each do |entry|
        queue.push(entry)
      end
    end
  end

  class TreeNode
    def initialize(parent=nil)
      @parent = parent
      @suffix = nil
      @matches = []
      @children = {}
    end

    attr_reader :matches, :children, :parent
    attr_accessor :suffix


    def find(char)
      @children[char.to_sym] || (suffix && suffix.find(char.to_sym))
    end
 
    def add_match(str)
      @matches << str
    end

    def child_for(char)
      @children[char.to_sym] ||= TreeNode.new(self)
    end

    def find_suffix(char)
      failure = parent.suffix
      while !failure.find(char) && failure.parent
        failure = failure.suffix
      end

      suffix = failure.find(char)
      if suffix
        @matches.push(*suffix.matches)
      elsif !failure.parent
        suffix = failure
      end

      suffix
    end

  end
end
