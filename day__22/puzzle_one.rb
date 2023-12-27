Brick = Struct.new(:lx, :ly, :lz, :rx, :ry, :rz)
Coordinate = Struct.new(:x, :y, :z)

def main
  t1 = Time.now
  bricks, max_x, max_y, max_z = parse_file([], 0, 0, 1)
  bricks.sort_by!(&:lz)
  # visualize(bricks, max_x, max_y, max_z)
  collapse(bricks, [])
  # visualize(bricks, max_x, max_y, max_z)
  removable = 0
  bricks.each do |brick|
    removable += 1 if removable?(bricks, brick)
  end
  t2 = Time.now
  puts removable
  puts t2 - t1
end

def parse_file(bricks, max_x, max_y, max_z)
  File.foreach('input.txt', chomp: true) do |line|
    left, right = line.split('~')
    lx, ly, lz = left.split(',').map(&:to_i)
    rx, ry, rz = right.split(',').map(&:to_i)
    bricks << Brick.new(lx, ly, lz, rx, ry, rz)
    max_x = [max_x, lx, rx].max
    max_y = [max_y, ly, ry].max
    max_z = [max_z, lz, rz].max
  end

  [bricks, max_x, max_y, max_z]
end

# logic to make bricks fall
def collapse(bricks, occupied)
  bricks.each_with_index do |brick, i|
    if brick.lx != brick.rx
      range = (brick.lx..brick.rx)
      lowest = 0
      range.each do |x|
        lowest = [lowest, (occupied.filter { |c| c.x == x && c.y == brick.ly }.max_by(&:z)&.z || 0) + 1].max
      end
      brick.lz = lowest
      brick.rz = lowest
      range.each do |x|
        occupied << Coordinate.new(x, brick.ly, brick.lz)
      end
    elsif brick.ly != brick.ry
      range = (brick.ly..brick.ry)
      lowest = 0
      range.each do |y|
        lowest = [lowest, (occupied.filter { |c| c.x == brick.lx && c.y == y }.max_by(&:z)&.z || 0) + 1].max
      end
      brick.lz = lowest
      brick.rz = lowest
      range.each do |y|
        occupied << Coordinate.new(brick.lx, y, brick.lz)
      end
    else
      diff = brick.rz - brick.lz
      lowest = (occupied.filter { |c| c.x == brick.lx && c.y == brick.ly }.max_by(&:z)&.z || 0) + 1
      brick.lz = lowest
      brick.rz = lowest + diff
      (brick.lz..brick.rz).each do |z|
        occupied << Coordinate.new(brick.lx, brick.ly, z)
      end
    end
  end
end

# determine if brick can be removed
def removable?(bricks, brick)
  can_be_removed = true
  supported = bricks.filter { |b| b.lz == (brick.rz + 1) && overlap?(b, brick) }
  supported.each do |sup_brick|
    supporters = bricks.filter { |b| b.rz == (sup_brick.lz - 1) && overlap?(b, sup_brick) && b != brick } # determine if the supported brick has any other bricks to support it
    can_be_removed = false if supporters.empty?
  end
  can_be_removed
end

def overlap?(brick_a, brick_b)
  x_overlap = [brick_a.rx, brick_b.rx].min - [brick_a.lx, brick_b.lx].max + 1
  y_overlap = [brick_a.ry, brick_b.ry].min - [brick_a.ly, brick_b.ly].max + 1
  x_overlap.positive? && y_overlap.positive?
end

# visual helper
def visualize(bricks, max_x, max_y, max_z)
  x_side = Array.new(max_z + 1) { Array.new(max_x + 1, '.') }
  y_side = Array.new(max_z + 1) { Array.new(max_y + 1, '.') }
  x_side.first.map! { '-' }
  y_side.first.map! { '-' }
  identifier = 'A'
  bricks.each do |brick|
    if brick.lx != brick.rx
      # place range on x_side, single on y_side
      range = (brick.lx..brick.rx)
      replacement = ''
      range.size.times { replacement << "#{identifier}," }
      x_side[brick.lz][range] = replacement.split(',')
      y_side[brick.lz][brick.ly] = replacement.split(',').first
    elsif brick.ly != brick.ry
      # place range on y_side, single on x_side
      range = (brick.ly..brick.ry)
      replacement = ''
      range.size.times { replacement << "#{identifier}," }
      y_side[brick.lz][range] = replacement.split(',')
      x_side[brick.lz][brick.lx] = replacement.split(',').first
    elsif brick.lz != brick.rz
      # stack singles in column on both x_side and y_side
      (brick.lz..brick.rz).each do |z|
        x_side[z][brick.lx] = Marshal.load(Marshal.dump(identifier))
        y_side[z][brick.ly] = Marshal.load(Marshal.dump(identifier))
      end
    else
      # place single cube on both x_side and y_side
      x_side[brick.lz][brick.lx] = Marshal.load(Marshal.dump(identifier))
      y_side[brick.lz][brick.ly] = Marshal.load(Marshal.dump(identifier))
    end
    identifier.next!
  end
  x_side.reverse.each { puts _1.inspect }
  puts '--------------------'
  y_side.reverse.each { puts _1.inspect }
  puts '!!!!!!!!!!!!!!!!!!!!'
end

main
