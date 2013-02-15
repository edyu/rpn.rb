#!/usr/bin/env ruby
# Ed Yu

#class NilClass
#  def strip
#    puts "\ngoodbye"
#    exit
#  end
#end

class StackUnderflowError < IndexError
end

class Array
  def checked_pop(n=1)
    raise StackUnderflowError unless length >= n
    pop(n)
  end
end

module ReversePolish

  class Calculator

    def initialize
      @stack = []
    end

    def input(token)
      result = case token
        when /^[-+]?(\d*\.\d+|\d+\.\d*)$/                     # float
          token.to_f
        when /^[-+]?(\d*\.\d+|\d+\.\d*|\d+)(e|E)[-+]?\d+$/    # scientific
          token.to_f
        when /^[-+]?\d+$/                                     # integer
          token.to_f
        when /^[+-\/\*]$/                                     # arithmetic
          op1, op2 = @stack.checked_pop(2)
          op1.send token.to_sym, op2
        when /c/i                                             # reset stack
          @stack.clear
          nil
        when /sum/i                                           # summation
          # don't use @stack.inject directly as it breaks encapsulation
          result = @stack.checked_pop(@stack.size).inject(0, :+)
          @stack.clear
          result
        when /mul/i
          # don't use @stack.inject directly as it breaks encapsulation
          result = @stack.checked_pop(@stack.size).inject(:*) || 0
          @stack.clear
          result
        when /!/                                              # factorial
          op = @stack.checked_pop[0]
          #result = (1..op.to_i).inject(1, :*)
          result = Math.gamma(op + 1)
        else
          method = token.downcase.to_sym                      # math functions
          if Math.respond_to? method
            arity = Math.method(method).arity
            op = @stack.checked_pop(arity)
            Math.send token.to_sym, *op
          elsif Math.constants.include?(token.upcase.to_sym)  # math constants
            Math.const_get(token.upcase.to_sym)
          else #ignore
          end
        end
      @stack.push result if result
      result
    end
  end

  class CalculatorProgram

    def initialize
      @calculator = Calculator.new
    end

    def run(prompt='> ', quit='q')
      puts "type '#{quit}' to quit"
      loop do
        begin
          print(prompt)
          line = gets.strip
          tokens = line.split
          tokens.each do |token|
            return if token == quit
            result = @calculator.input token
            output(result) if result
          end
        rescue NoMethodError => e # EOF
          return if e.message =~ /strip/
          warn e.message
        rescue StackUnderflowError => e
          warn "not enough operands"
        rescue => e
          warn e.message
        end
      end
    end

    def output(num)
      if num == num.to_i.to_f
        puts num.to_i
      else
        puts num
      end
    end
  end
end

if __FILE__ == $0
  rp = ReversePolish::CalculatorProgram.new
  rp.run('> ', 'q')
  puts "goodbye"
end
