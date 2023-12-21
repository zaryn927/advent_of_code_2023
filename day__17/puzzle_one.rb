State = Struct.new(:i, :j, :di, :dj, :distance)
GRID = []
VISITED = {}
QUEUE = Hash.new { |hash, key| hash[key] = [] }

def main
  File.foreach('input.txt', chomp: true) { GRID << _1.split('').map(&:to_i) }

  move_and_add_state(cost: 0, i: 0, j: 0, di: 0, dj: 1, distance: 1)
  move_and_add_state(cost: 0, i: 0, j: 0, di: 1, dj: 0, distance: 1)

  loop do
    current_cost = QUEUE.keys.min
    states = QUEUE.delete(current_cost)

    states.each do |state|
      move_and_add_state(cost: current_cost, i: state.i, j: state.j, di: state.dj, dj: -state.di, distance: 1) # RIGHT
      move_and_add_state(cost: current_cost, i: state.i, j: state.j, di: -state.dj, dj: state.di, distance: 1) # LEFT

      next unless state.distance < 3

      move_and_add_state(cost: current_cost, i: state.i, j: state.j, di: state.di, dj: state.dj, distance: state.distance + 1) # STRAIGHT
    end
  end
end

def move_and_add_state(cost:, i:, j:, di:, dj:, distance:)
  i += di
  j += dj

  return if i.negative? || j.negative? || (i >= GRID.size) || (j >= GRID.first.size)

  new_cost = cost + GRID[i][j]

  if (i == GRID.size - 1) && (j == GRID.first.size - 1)
    puts "LOWEST: #{new_cost} at #{i},#{j}"
    exit 0
  end

  state = State.new(i, j, di, dj, distance)

  return if VISITED[state]

  QUEUE[new_cost] << state
  VISITED[state] = 'this value is unimportant but hash is faster than checking if state exists in list'
end

main
