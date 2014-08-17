require 'ostruct'

module Result
  def self.parse_results res
    columns = res["columns"]#.map{|s| s.to_sym}
    
    if res["data"]
      res["data"].map do |result|
        parse_result result, columns
      end
    else
      raise SyntaxError.new(res["message"])
    end
  end

  def self.parse_result result, columns
    h = columns_to_hash result, columns
    group_hashs(h)
  end

  def self.group_hashs hsh
    hsh.each do |key, value|
      self.group_hash(hsh, key, value) if value.is_a? Hash
    end #.inject({}){|hash, tuple| hash[tuple[0].to_sym] = tuple[1]; hash}
    one_column_expand hsh
  end

  def self.columns_to_hash result, columns
    result = result.map do |field| 
      if field.is_a?(Hash)
        parse_field_hash(field)
      else
        field
      end
    end    
    [columns, result].transpose.to_h
  end

  def self.parse_field_hash(field)
    id = field.fetch("self"){""}.split("/", -2).last;
    data = field["data"]
    # data = field["data"].merge(_node_: {id: id.to_i}) if id
    data = field["data"].merge(id: id.to_i) if id
    data
  end

  def self.hash_2_object(value)
    value[:_node_] ||= {}
    value[:_node_][:labels] ||= []
    classes = value[:_node_][:labels]
    klass = classes.map{|klass| Object.const_defined?(klass) ? Object.const_get(klass) : nil}.compact.first || OpenStruct
    attributes = value.map{|k,v| [k.to_sym, v]}.to_h
    klass.new(attributes)
  end

  private

  def self.group_hash hsh, key, value
    value[:_node_] ||= {}
    if hsh.has_key? "#{key}_id"
      id = hsh.delete("#{key}_id")
      # value[:_node_][:id] = id
      value[:id] = id
    end
    group_node_or_rel hsh, key, :labels, value
    group_node_or_rel hsh, key, :type, value
    hsh[key] = hash_2_object(value)
  end

  def self.group_node_or_rel hsh, field, func, value
    if hsh.has_key? "#{field}_#{func}"
      val = hsh.delete("#{field}_#{func}")
      # (value[:_node_] ||= {})[func] = #{func}
      value[:_node_][func] = val
    end
  end

  def self.one_column_expand hsh
    if hsh.length > 1
      keys = hsh.keys.map{|k| k.to_sym}
      Struct.new(*keys).new(*hsh.values)
    else
      hsh.values.first
    end
  end
end
