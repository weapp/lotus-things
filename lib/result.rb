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
      if value.is_a? Hash
        value[:_node_] ||= {}
        if hsh.has_key? "#{key}_id"
          id = hsh.delete("#{key}_id")
          # value[:_node_][:id] = id
          value[:id] = id
        end
        if hsh.has_key? "#{key}_labels"
          labels = hsh.delete("#{key}_labels")
          # (value[:_node_] ||= {})[:labels] = labels
          value[:_node_][:labels] = labels
        end
        if hsh.has_key? "#{key}_type"
          type = hsh.delete("#{key}_type")
          # (value[:_node_] ||= {})[:type] = type
          value[:_node_][:type] = type
        end
        hsh[key] = hash_2_object(value)
      end
    end #.inject({}){|hash, tuple| hash[tuple[0].to_sym] = tuple[1]; hash}

    if hsh.length > 1
      keys = hsh.keys.map{|k| k.to_sym}
      Struct.new(*keys).new(*hsh.values)
    else
      hsh.values.first
    end
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
end
