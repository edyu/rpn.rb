#!/usr/bin/env ruby
# Ed Yu

class NilClass
  def strip
    puts "\ngoodbye"
    exit
  end
end

class StackUnderflowError < IndexError
end

class Array
  def checked_pop(n=1)
    raise StackUnderflowError unless length >= n
    pop(n)
  end
end

class Calculator

  def initialize
    @stack = []
  end

  def calculate(token)
    case token
    when /^[-+]?(\d*\.\d+|\d+\.\d*)$/
      op = token.to_f
      @stack.push op
      token
    when /^[-+]?\d+$/
      op = token.to_f
      @stack.push op
      token
    when /^[+-\/\*]$/
      op1, op2 = @stack.checked_pop(2)
      result = op1.send token.to_sym, op2
      @stack.push result
      result
    when /sum/i
      # don't use @stack.inject directly as it breaks encapsulation
      result = @stack.checked_pop(@stack.size).inject(0, :+)
      @stack.clear
      @stack.push result
      result
    when /!/
      op = @stack.checked_pop[0]
      #result = (1..op.to_i).inject(1, :*)
      result = Math.gamma(op + 1)
      @stack.push result
      result
    else
      method = token.downcase.to_sym
      if Math.respond_to? method
        arity = Math.method(method).arity
        op = @stack.checked_pop(arity)
        result = Math.send token.to_sym, *op
        @stack.push result
        result
      elsif Math.constants.include?(token.upcase.to_sym)
        op = Math.const_get(token.upcase.to_sym)
        @stack.push op
        op
      else #ignore
      end
    end
  end
end

class CalculatorProgram
  def initialize
    @calculator = Calculator.new
  end

  def run
    puts "type 'q' to quit"
    loop do
      print("> ")
      line = gets.strip
      tokens = line.split
      tokens.each do |token|
        begin
          if token == 'q'
            puts "goodbye"
            return
          end
          result = @calculator.calculate token
          if result
            puts result
          else
            warn "you must input a number or a function (type 'q' to quit)"
          end
        rescue StackUnderflowError => e
          warn "not enough operands"
        rescue => e
          warn e.message
        end
      end
    end
  end
end

if __FILE__ == $0
  rp = CalculatorProgram.new
  rp.run
end
