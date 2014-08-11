require 'neography'
require 'cypherites'

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
    labels = get_labels(collection, entity)
    
    hsh = entity.serializable_hash
    hsh.each {|k, v| hsh.delete(k) if v.nil? }

    res = query
            .merge("(n#{labels} ?)", hsh)
            .return("n, id(n) as id")
            .execute

    entity.id = res.first.id
    entity
  end

  def create collection, entity
    labels = get_labels(collection, entity)

    res = query
            .create("(n#{labels} ?)", entity.serializable_hash)
            .return("n, id(n) as id")
            .execute

    # res = query
    #   .create("(n#{labels} {props})")
    #   .return("n, id(n) as id")
    #   .execute({props: entity.serializable_hash})

    entity.id = res.first.id
    entity
  end

  def update collection, entity
    labels = get_labels(collection, entity)

    hsh = entity.serializable_hash
    hsh.delete(:id)
    hsh.delete("id")

    res = query
            .start("n=node(?)", entity.id)
            .set("n = ?", hsh)
            .execute
    
    entity
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
    #.tap{|q| puts;pp q;puts}
    query.match("(node#{c collection})").order_by("id(node) ASC").return_node("node").execute
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
      .start("node=node(?)", id)
      .return_node("node")
      .order_by("id(node) DESC")
      .first
  end

  def first collection
    query
      .match("(node#{c collection})")
      .return_node("node")
      .order_by("id(node) ASC")
      .first
  end

  def last collection
    query
      .match("(node#{c collection})")
      .return_node("node")
      .order_by("id(node) DESC")
      .last
  end

  def clear collection
    query
      .match("(n#{c collection})").optional_match("(n)-[r]-()")
      .delete(:n).delete(:r)
      .execute
  end

  def query collection=nil, repository=nil, &blk
    q = Cypherites::Query.new(method(:execute_query)).tap do |q|
      q.instance_eval(&blk) if block_given?
    end
  end

  def execute_query query, *params
    query = query.to_cypher if query.respond_to? :to_cypher
    # begin    
      res = @neo.execute_query(query, *params)
    # rescue Exception => e
    #   puts
    #   pp query
    #   pp params
    #   puts      
    # end
    Result::parse_results(res)
  end

  def create_relationship(role, node1, node2)
    @neo.create_relationship(role, node1.id, node2.id)
  end

  def set_relationship_properties(rel, attrs)
    @neo.set_relationship_properties(rel, attrs)
  end

  private

  def get_labels collection, entity
    labels = ":#{entity.class}"
    labels_coll = c collection

    labels << labels_coll if labels_coll != labels
    labels
  end

  def c collection, opts={}
    raise ArgumentError.new("collection is nil") unless collection
    name = ""
    name << ":" if !opts[:only_name]
    name << collection.capitalize
    name if collection
  end
end
