class PeopleService
  attr_accessor :people

  def initialize(people)
    @people = people
  end

  def count_email_characters
    hash = {}
    @people.each do |p|
      next unless p.email
      p.email.chars.each do |c|
        # nil.to_i == 0
        # Though I'm not sure if this is faster
        # than just checking if the key exists...hmm
        hash[c] = hash[c].to_i + 1
      end
    end
    hash.sort_by { |_k, v| -v }
  end

  # Just getting the edit distance between all email addresses
  # Pretty horrendous runtime
  def find_duplicate_emails
    duplicates = {}

    @people.each_with_index do |a, i|
      j = i + 1
      while j < @people.count
        b = @people[j]
        a_email = a.email
        b_email = b.email
        next if a_email.nil? || b_email.nil? || i == j

        # Edit distance between strings
        dl_dist = DamerauLevenshtein.distance(a_email, b_email)

        # Edit distance of 0, 1, or 2 will be flagged
        if dl_dist < 3
          if duplicates.key?(a_email)
            unless duplicates[a_email].include?(b_email)
              duplicates[a_email] << b_email
              duplicates[b_email] << a_email
            end
          else
            duplicates[a_email] = [b_email]
            duplicates[b_email] = [a_email]
          end
        end
        j += 1
      end
    end

    duplicates
  end

  # My first attempt, which I was unable to successfully implement
  # I *think* the Trie is implemented correctly, but I'm stuck
  # on the step of actually identifying duplicates in the tree.
  # Should be faster and have better space-complexity
  def populate_trie
    trie = Trie.new
    @people.each do |p|
      trie.insert(p.email) if p.email
    end

    trie
  end
end
