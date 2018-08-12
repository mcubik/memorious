# Memorious 

Just another memoization gem, created for fun.

## Example

```ruby
# Levenshtein edit distance
class Levenshtein
  include Memorious

  REPLACE_COST = 1

  def self.between(a, b, replace_cost = REPLACE_COST)
    new(a, b, replace_cost).calculate
  end

  def initialize(a, b, replace_cost)
    @replace_cost = replace_cost
    @a = a
    @b = b
  end

  memoize def calculate(a, b)
    # This implementation doesn't pretend to be efficient. It's just illustrative.
    return a.size if b.empty?
    return b.size if a.empty?
    return calculate(a.drop_last, b.drop_last) if a.last == b.last
    [calculate(a.drop_last, b) + 1,
     calculate(a, b.drop_last) + 1, 
     calculate(a.drop_last, b.drop_last) + @replace_cost].min 
  end
end

class String
  def last
    self[-1]
  end

  def drop_last
    self[0..-2]
  end

  def edit_distance(other)
    Levenshtein.between(self, other)
  end

end

('word' * 100).edit_distance('world' * 100) 
# => 100

```
