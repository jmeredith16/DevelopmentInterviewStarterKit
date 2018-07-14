class Trie
  attr_reader :root

  def initialize
    @root = Node.new(nil)
  end

# Detect dups on insert, general outline
#  - traverse the tree until the character we want to insert doesn't exist
#  - set a flag to 1 to indicate that we're checking for typos
#  - take the next character in our string, try to continue the traversal for all children that do exist.
  #  - if any of them allow for a complete insertion of the string, then there was a typo in that one character that missed
  #  - if any of them reach another point (flag == 1) where they're trying to visit a node that doesn't exist, then break that path
#  - if all flag == 1 traversals failed, completely insert the string

  def insert(word)
    node = @root
    word.chars.each do |c|
      child = node.insert(c)
      node = child
    end

    # Word has ended
    node.end_of_word = true
  end

  def has_word?(word)
    node = @root
    word.chars.each do |c|
      return false unless node.child_exists?(c)
      node = node[c]
    end

    node.end_of_word
  end
end
