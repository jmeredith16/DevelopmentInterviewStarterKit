# This is a Node class for the Trie data structure
class Node
  # most implementations seem to be using an array for child nodes
  # hash makes more sense to me, but that might be the wrong approach
  attr_reader :char, :children
  attr_accessor :end_of_word
  def initialize(char)
    @char = char
    @children = {}
    @end_of_word = false
  end

  def [](ch)
    @children[ch]
  end

  def child_exists?(ch)
    @children.key?(ch)
  end

  def insert(ch)
    return self[ch] if child_exists?(ch)

    child = Node.new(ch)
    @children[ch] = child
  end
end
