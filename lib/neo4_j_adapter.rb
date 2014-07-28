require 'ostruct'

require 'neography'

Neography.configure do |config|
  config.protocol             = "http://"
  config.server               = "localhost"
  config.port                 = 7474
  config.directory            = ""  # prefix this path with '/'
  config.cypher_path          = "/cypher"
  config.gremlin_path         = "/ext/GremlinPlugin/graphdb/execute_script"
  config.log_file             = "neography.log"
  config.log_enabled          = false
  config.slow_log_threshold   = 0    # time in ms for query logging
  config.max_threads          = 20
  config.authentication       = nil  # 'basic' or 'digest'
  config.username             = nil
  config.password             = nil
  config.parser               = MultiJsonParser
  config.http_send_timeout    = 1200
  config.http_receive_timeout = 1200
end

class Neo4JAdapter
  def initialize(rest_client = Neography::Rest)
    @neo = rest_client.new
  end

  def all collection
    # res = @neo.execute_query("MATCH (director)-[:`DIRECTED`]->(movie) RETURN labels(movie) as movie_labels, movie, labels(director) as director_labels, director LIMIT 2")
    # res = @neo.execute_query("MATCH object RETURN id(object) as id, labels(object)[0] as label, object LIMIT 2")
    # res = @neo.execute_query('MATCH (object) WHERE object.name = "World" RETURN id(object) as object_id, labels(object) as object_labels, object LIMIT 100')
    res = @neo.execute_query('MATCH (object) RETURN id(object) as object_id, labels(object) as object_labels, object')
    parse_results res
  end

  private

  def parse_results res
    columns = res["columns"]#.map{|s| s.to_sym}
    
    res["data"].map do |result|
      parse_result result, columns
    end
  end

  def parse_result result, columns
    h = columns_to_hash result, columns
    group_hashs(h)
  end

  def group_hashs hsh
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
        hsh[key] = hash_2_object(value)
      end
    end #.inject({}){|hash, tuple| hash[tuple[0].to_sym] = tuple[1]; hash}

    if hsh.length > 1
      Struct.new(*hsh.keys.map{|k| k.to_sym}).new(*hsh.values)
    else
      hsh.values.first
    end
  end

  def columns_to_hash result, columns
    result = result.map do |field| 
      if field.is_a?(Hash)
        id = field.fetch("self"){""}.split("/", -2).last;
        data = field["data"]
        # data = field["data"].merge(_node_: {id: id.to_i}) if id
        data = field["data"].merge(id: id.to_i) if id
        data
      else
        field
      end
    end
    
    [columns, result].transpose.to_h
  end

  def hash_2_object(value)
    value[:_node_][:labels] ||= []
    classes = value[:_node_][:labels]
    klass = classes.map{|klass| Object.const_defined?(klass) ? Object.const_get(klass) : nil}.compact.first || OpenStruct

    klass.new(value.map{|k,v| [k.to_sym, v]}.to_h)
  end
end
