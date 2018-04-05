class Node
  attr_accessor :name, :edge_hash

  def initialize(name) 
    self.name = name
    self.edge_hash = {}
  end

  def add_edge(node)
    self.edge_hash[node.name] = true
  end

  def related_to?(node)
    self.edge_hash.has_key?(node.name)
  end

  def edges
    self.edge_hash.keys
  end

end

class Dependencies

  attr_accessor :nodes

  def initialize
    @nodes = {}
  end

  # Build the graph out of nodes w/ edges
  def add_direct(key,deps)
    unless @nodes.has_key?(key)
      @nodes[key] = Node.new(key)
    end
    deps.each do |n|
      self.add_direct(n,[])
      @nodes[key].add_edge(@nodes[n])
    end
  end

  # Travese the graph, strting with the passed in node
  def dependencies_for(key)
    @visited = {}
    deps = {}
    deps = self.dfs(key,deps)
    return deps.keys.sort
  end

  def dfs(key,list)
    @visited[key] = true
    @nodes[key].edges.each do |edge|
      next if @visited.has_key?(edge)
      list.merge self.dfs(@nodes[edge].name,list)
      list[edge] = true
    end
    return list
  end

end
