require 'set'
Vertex = Struct.new(:y, :x)
Edge = Struct.new(:v1, :v2, :distance)
$input = File.readlines('input.txt', chomp: true)
$finish = nil
$v_to_e = {}

def main
  t1 = Time.now

  vertices = find_vertices
  first = Vertex.new(0, 1)
  vertices << first
  $finish = Vertex.new($input.size - 1, $input.last.size - 2)
  vertices << $finish
  vertices.each { puts _1 }
  puts vertices.count

  puts '----------------------'

  edges = find_edges(first, vertices, Set[], Set[])
  edges.each { puts _1 }
  puts edges.count

  vertices.each do |v|
    connected = edges.filter { |e| e.v1 == v || e.v2 == v }
    $v_to_e[v] = connected
  end

  distances = step(first, [])
  puts distances.max
  puts Time.now - t1
end

def step(current_node, seen)
  if current_node == $finish
    return [0]
  end
  seen << current_node
  path_lengths = []

  edges = $v_to_e[current_node]

  edges.each do |edge|
    neighbor = [edge.v1, edge.v2].reject { |v| v == current_node }.first
    next if seen.include?(neighbor)

    pls = step(neighbor, seen)
    pls.each { |pl| path_lengths << pl + edge.distance }
  end

  seen.delete(current_node)
  path_lengths
end

def find_vertices
  vertices = Set[]
  $input.each_with_index do |row, y|
    row.split('').each_with_index do |point, x|
      vertices << Vertex.new(y, x) if point == '.' && get_neighbors([y, x]).all? { |n| ['#', '<', '>', '^', 'v'].include?(n.last&.last) }
    end
  end
  vertices
end

def find_edges(vertex, vertices, edges, visited)
  y = vertex.y
  x = vertex.x
  visited << [y, x]
  neighbors = get_neighbors([y, x])
  next_steps = neighbors.reject { |_, v| [nil, '#'].include?(v&.last) || visited.include?(v&.first) }.map { |_, v| v&.first }

  queue = []
  next_steps.each do |s|
    new_visits, vertex2 = traverse(s, vertices, [[y, x]])
    new_visits.each { |v| visited << v }
    edge = Edge.new(vertex, vertex2, new_visits.size)
    edges << edge
    return edges if vertex2 == vertices.to_a[-1]

    queue << vertex2
  end
  queue.each { |v| find_edges(v, vertices, edges, visited) unless visited.include?([v.y, v.x]) }
  edges
end

def traverse(point, vertices, visited)
  y, x = point

  until vertices.filter { |v| v.x == x && v.y == y }.one?
    visited << [y, x]
    next_step = get_neighbors([y, x]).reject { |_, v| visited.include?(v&.first) || [nil, '#'].include?(v&.last) }.map { |_, v| v&.first }.first
    y, x = next_step
  end

  [visited, vertices.filter { |v| v.x == x && v.y == y }.first]
end

def get_neighbors(coordinate)
  y, x = coordinate
  left = [[y, x - 1], $input[y][x - 1]] if x.positive?
  right = [[y, x + 1], $input[y][x + 1]] if x < $input.first.size - 1
  up = [[y - 1, x], $input[y - 1][x]] if y.positive?
  down = [[y + 1, x], $input[y + 1][x]] if y < $input.size - 1
  { left: left, right: right, up: up, down: down }
end

main
