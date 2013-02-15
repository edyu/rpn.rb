#!/usr/bin/env ruby
# Ed Yu

class NilClass
  def strip
    puts "\ngoodbye"
    exit
  end
end

class ReversePolish

  def initialize
    @stack = []
  end

  def run
    puts "type 'q' to quit"
    loop do
      quit = false
      print("> ")
      line = gets.strip
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
            puts token
          when /^[-+]?\d+$/
            op = token.to_i
            @stack.push op
            puts token
          when /^[+-\/\*]$/
            if @stack.length < 2
              warn "not enough operands"
              next
            end
            op1, op2 = @stack.pop(2)
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
              warn "not enough operands"
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
                warn "not enough operands"
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
              warn "you must input a number or a function"
            end
          end
        rescue => e
          warn e.message
        end
      end
    end
  end
end

rp = ReversePolish.new

rp.run
