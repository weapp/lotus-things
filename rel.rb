
class Sym
  attr_accessor :syms

  def initialize(*syms)
    self.syms = syms.flatten
  end

  def to_ary
    [ :'[', syms , :']' ]
  end

  def method_missing *args
    args = args.map{|a| a.respond_to?(:syms) ? a.syms : a}
    self.class.new(self.syms + args)
  end

  def to_s(bc=0)
    bracket_count = bc
    self.syms.map do |sym|
      if sym.is_a? Hash
        s = sym.map{|k,v| "#{k}:#{v.to_s(1)}"}.join("")
        s = "[#{s}]"
      else
        s = sym.to_s
      end


      if s == "["
        bracket_count += 1
      elsif s== "]"
        bracket_count -= 1
      end

      if s == ">"
        "->"
      elsif s == "<"
        "<-"
      elsif s =~ /^[a-zA-Z0-9]+$/
        if bracket_count > 0
          s
        else
          "(#{s})"
        end
      else
        s
      end
    end.join("")
  end

end

class Rel
  def call(&block)
    instance_eval(&block)
  end

  def method_missing method_name
    Sym.new(method_name)
  end
end