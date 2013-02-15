#!/usr/bin/env ruby
# Ed Yu

class NilClass
  def chomp
    puts "goodbye"
    exit
  end
end

class ReversePolish

  def initialize
    @stack = []
  end

  def run
    puts "type 'q' to quit"
    while true
      print("> ")
      line = gets.chomp.strip
      case line
      when "q"
        break
      when /^[-+]?(\d*\.\d+|\d+\.\d*)$/
        op = line.to_f
        @stack.push op
        puts op
      when /^[-+]?\d+$/
        op = line.to_i
        @stack.push op
        puts op
      when /^[+-\/\*]$/
        if @stack.length < 2
          puts "not enough operands"
          next
        end
        op2 = @stack.pop
        op1 = @stack.pop
        result = op1.send line.to_sym, op2
        @stack.push result
        puts result
      when //
        # ignore
      else
        puts "you must input a number or an operand (+ - * /)"
      end
    end
    puts "goodbye"
  end
end

rp = ReversePolish.new

rp.run
