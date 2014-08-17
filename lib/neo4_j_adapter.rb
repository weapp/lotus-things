require 'cypherites'
require 'headjack'

require_relative 'result'

class Neo4JAdapter
  def initialize(mapping, uri="http://localhost:7474", rest_client = Headjack::Connection)
    @mapping = mapping
    @neo = rest_client.new(url: uri)
  end

  def persist collection, entity
    entity.id ? update(collection, entity) : create(collection, entity)
  end

  def create collection, entity
    labels = get_labels(collection, entity)

    # res = query(collection)
    #         .create("(n#{labels} ?)", entity.serializable_hash)
    #         .return("n, id(n) as id")
    #         .execute

    hsh = entity.serializable_hash
    hsh.delete(:id)
    hsh.delete("id")
    hsh.each {|k, v| hsh.delete(k) if v.nil? }

    res = query(collection)
      .create("(n#{labels} {props})")
      .return("n, id(n) as id")
      .execute({props: hsh})

    entity.id = res.first.id
    entity
  end

  def update collection, entity
    labels = get_labels(collection, entity)

    hsh = entity.serializable_hash
    hsh.delete(:id)
    hsh.delete("id")

    res = query(collection)
            .start("n=node(?)", entity.id)
            .set("n = ?", hsh)
            .execute
    
    entity
  end

  def delete collection, entity
    # @neo.delete_node!(entity.id)
    # @neo.execute_query("MATCH (object) WHERE id(object) = #{entity.id} DELETE object")

    query(collection)
      .start("object=node(?)", entity.id)
      .optional_match("(object)-[relation]-()")
      .delete(:object)
      .delete(:relation)
      .execute
  end

  def all collection
    #.tap{|q| puts;pp q;puts}
    query(collection).match("(node#{c collection})").order_by("id(node) ASC").return_node("node").execute
  end

  def find collection, id
    # node = @neo.get_node(id)
    # value = parse_field_hash(node)
    # value[:_node_] ||= {}
    # value[:_node_][:labels] ||= [entity.class.to_s]
    # hash_2_object value

    # res = @neo.execute_query("MATCH (object) WHERE id(object) = #{id} RETURN id(object) as object_id, labels(object) as object_labels, object ORDER BY id(object) DESC LIMIT 1")
    query(collection)
      .start("node=node(?)", id)
      .return_node("node")
      .order_by("id(node) DESC")
      .first
  end

  def first collection
    query(collection)
      .match("(node#{c collection})")
      .return_node("node")
      .order_by("id(node) ASC")
      .first
  end

  def last collection
    query(collection)
      .match("(node#{c collection})")
      .return_node("node")
      .order_by("id(node) DESC")
      .last
  end

  def clear collection
    query(collection)
      .match("(n#{c collection})").optional_match("(n)-[r]-()")
      .delete(:n).delete(:r)
      .execute
  end

  def query collection=nil, repository=nil, &blk
    q = Cypherites::Query.new(method(:execute_query)).tap do |q|
      q.instance_eval(&blk) if block_given?
    end
  end

  # def query collection, repository=nil, &blk
  #   q = Cypherites::Query.new(->(query, params={}){execute_query(collection, query, params)}).tap do |q|
  #     def q.where(hsh)
  #       hsh.each do |k, v|
  #         super("node.#{k} = ?", v)
  #       end
  #       self
  #     end
  #     q
  #       .match("(node#{c collection})")
  #       .return_node("node")
  #       .instance_eval(&blk) if block_given?
  #   end
  # end

  # def execute_query collection, query, params={}
  #   pp "<--"
  #   pp collection
  #   pp "-->"
  #   query = query.to_cypher if query.respond_to? :to_cypher
  #   # begin    
  #     res = @neo.call(query, params)
  #   # rescue Exception => e
  #   #   puts
  #   #   pp query
  #   #   pp params
  #   #   puts      
  #   # end
  #   # Result::parse_results(res)
  #   res.map{|entity| @mapping.collections[collection].deserialize(entity)}
  # end

  def execute_query query, params={}
    query = query.to_cypher if query.respond_to? :to_cypher
      res = @neo.call(query: query, params: params, mode: :cypher, filter: :all)
    Result::parse_results(res)
  end

  def create_relationship(role, node1, node2)
    query
      .match("(a)")
      .match("(b)")
      .where("id(a) = ?", node1.id)
      .where("id(b) = ?", node2.id)
      .create("(a)-[r:#{role}]->(b)")
      .return("r")
      .first
  end

  def set_relationship_properties(rel, attrs)
    res = query
      .match("(a)-[r]->(b)")
      .where("id(r) = ?", rel.id)
      .set("r={attrs}")
      .return("r")
      .execute(attrs: attrs)
  end

  private

  def get_labels collection, entity
    labels = ""#":#{entity.class}"
    labels = ":#{entity.class}"
    labels_coll = c collection

    labels << labels_coll if labels_coll != labels
    labels
    
  end

  def c collection, opts={}
    raise ArgumentError.new("collection is nil") unless collection
    name = ""
    name << ":" if !opts[:only_name]
    name << collection.to_s.capitalize
    name if collection
  end
end
