require 'neography'

require_relative 'query'
require_relative 'result'

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

  def persist collection, entity
    puts "#{collection} : #{entity}"
  end

  def create collection, entity
    node = @neo.create_node(entity.serializable_hash)
    id = node["self"].split("/", -1).last
    @neo.add_label(id, entity.class.to_s)
    # value = parse_field_hash(node)
    # value[:_node_] ||= {}
    # value[:_node_][:id] ||= id.to_i
    # value[:_node_][:labels] ||= [entity.class.to_s]
    # r = hash_2_object value
    entity.id = id
  end

  def update collection, entity
    puts "#{collection} : #{entity}"
  end

  def delete collection, entity
    @neo.delete_node!(entity.id)
    # @neo.execute_query("MATCH (object) WHERE id(object) = #{entity.id} DELETE object")

    # query
    #   .start("object=node(?)", entity.id)
    #   # .match("(object)")
    #   # .where("id(object) = ?", entity.id)
    #   .optional_match("(object)-[relation]-()")
    #   .delete(:object)
    #   .delete(:relation)
    #   .execute
  end

  def all collection
    query.match("(object)").return_node("object").execute
  end

  def find collection, id
    # node = @neo.get_node(id)
    # value = parse_field_hash(node)
    # value[:_node_] ||= {}
    # value[:_node_][:labels] ||= [entity.class.to_s]
    # hash_2_object value

    # Neography::Node.load(id, @neo)

    # res = @neo.execute_query("MATCH (object) WHERE id(object) = #{id} RETURN id(object) as object_id, labels(object) as object_labels, object ORDER BY id(object) DESC LIMIT 1")
    query
      .start("object=node(?)", id)
      .return_node("object")
      .order_by("id(object) DESC")
      .limit(1)
      .execute
      .first
  end

  def first collection
    query
      .match("(object)")
      .return_node("object")
      .order_by("id(object) ASC")
      .limit(1)
      .execute
      .first
  end

  def last collection
    query
      .match("(object)")
      .return_node("object")
      .order_by("id(object) DESC")
      .limit(1)
      .execute
      .last
  end

  def clear
    query
      .match("(object)")
      .optional_match("(object)-[relation]-()")
      .delete(:object)
      .delete(:relation)
      .execute
  end

  def query collection=nil, repository=nil, &blk
    q = Query.new(method(:execute_query)).tap do |q|
      q.instance_eval(&blk) if block_given?
    end
  end

  def execute_query query
    query = query.to_cypher if query.respond_to? :to_cypher
    res = @neo.execute_query(query)
    Result::parse_results(res)
  end

  def create_relationship(role, node1, node2)
    @neo.create_relationship(role, node1.id, node2.id)
  end

  def set_relationship_properties(rel, attrs)
    @neo.set_relationship_properties(rel, attrs)
  end
end
