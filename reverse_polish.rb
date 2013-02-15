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
      quit = false
      print("> ")
      line = gets.chomp.strip
      tokens = line.split
      tokens.each do |token|
        begin
          case token
          when "q"
            puts "goodbye"
            exit
          when /^[-+]?(\d*\.\d+|\d+\.\d*)$/
            op = token.to_f
            @stack.push op
            puts op
          when /^[-+]?\d+$/
            op = token.to_i
            @stack.push op
            puts op
          when /^[+-\/\*]$/
            if @stack.length < 2
              puts "not enough operands"
              next
            end
            op2 = @stack.pop
            op1 = @stack.pop
            result = op1.send token.to_sym, op2
            @stack.push result
            puts result
          when /sum/i
            result = @stack.inject(:+) || 0
            @stack.clear
            @stack.push result
            puts result
          when /!/
            if @stack.length < 1
              puts "not enough operands"
              next
            end
            op = @stack.pop
            result = (1..op.to_i).inject(:*) || 1
            @stack.push result
            puts result
          else
            # ignore
            if Math.respond_to? token.downcase.to_sym
              if @stack.length < 1
                puts "not enough operands"
                next
              end
              op = @stack.pop
              result = Math.send token.to_sym, op
              @stack.push result
              puts result
            elsif Math.constants.include?(token.upcase.to_sym)
              op = Math.const_get(token.upcase.to_sym)
              @stack.push op
              puts op
            else
              puts "you must input a number or a
            end
          end
        rescue => e
          puts e.message
        end
      end
    end
  end
end

rp = ReversePolish.new

rp.run
