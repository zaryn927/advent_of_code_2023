require 'set'
def main
  nodes = Set[]
  edges = {}
  File.foreach('input.txt', chomp: true) do |line|
    key, values = line.split(': ')
    values = values.split
    nodes << key
    values.each do |v|
      nodes << v
      edges[Set[key, v]] = 1
    end
  end
  nodes = nodes.to_a
  n = nil
  e = nil
  until e == 3
    n, e = kargers(Marshal.load(Marshal.dump(nodes)), Marshal.load(Marshal.dump(edges)))
    puts e
  end
  puts n.first.size * n.last.size
  #puts ';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'
end

def kargers(nodes, edges)
  #t1 = Time.now
  ns = nodes.size
  while ns > 2
  #5.times do
    i = rand(edges.size)
    key = edges.keys[i]
    #puts "Key: #{key}"
    edges.delete(key)
    node_a = key.first
    node_b = key.to_a.last
    neighboring_edges = edges.filter { |k, _| (k.to_a - [node_a, node_b]).size == 1 }
    node_neighbors = Hash.new(0)
    neighboring_edges.each { |k, v| node_neighbors[k.to_a.reject { |n| [node_a, node_b].include?(n) }.first] += v }
    super_node = Set[node_a, node_b].flatten
    nodes.delete(node_a)
    nodes.delete(node_b)
    nodes << super_node
=begin
    node_neighbors.each { puts _1.inspect }
    puts '???????????????'
    edges.each { puts _1.inspect }
    puts edges.size
=end
    neighboring_edges.each { |k, _| edges.delete(k) }
    node_neighbors.each do |k, v|
      edges[Set[super_node, k]] = v
    end
=begin
    puts '-----------'
    edges.each { puts _1.inspect }
    puts edges.size
    puts '!!!!!!!!!!!!!!!!'
=end
    ns -= 1
  end
  # puts "Final: #{nodes.first} & #{nodes.last}"
  # puts "Remaining edges: #{edges}"
  [nodes, edges.values.first]
end

main
