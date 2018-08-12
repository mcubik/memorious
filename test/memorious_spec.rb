require 'memorious'

RSpec.describe Memorious do
  let(:fibo) { Fibonacci.new }

  it 'provides memoization' do
    # This calculation cannot be achived with a recurive function without
    # memoization
    expect(fibo.calculate(500)).to(
      eq(139423224561697880139724382870407283950070256587697307264108962948325571622863290691557658876222521294125)) # rubocop:disable all
  end

  it 'provides access to previous executions' do
    fibo.calculate(500)
    expect(fibo.method(:calculate).memory[[8]]).to eq(21)
  end
end

class Fibonacci
  include Memorious
  memoize def calculate(num)
    raise if num < 0
    return num if num.zero? || num == 1
    calculate(num - 1) + calculate(num - 2)
  end
end
