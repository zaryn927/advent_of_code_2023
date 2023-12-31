require 'matrix'

def main
  positions = []
  velocities = []
  File.foreach('input.txt', chomp: true) do |line|
    position, velocity = line.split('@')
    positions << Vector[*position.split(/[\s,]/).reject(&:empty?).map(&:to_f)]
    velocities << Vector[*velocity.split(/[\s,]/).reject(&:empty?).map(&:to_f)]
  end
  puts solve(positions, velocities)
end

def solve(positions, velocities)
  p1 = positions.first
  v1 = velocities.first

  eye = nil # to keep track of i outside local scope
  p2 = nil
  v2 = nil
  (1...velocities.size).each do |i|
    next unless v1.independent?(velocities[i])

    eye = i
    p2 = positions[i]
    v2 = velocities[i]
    break
  end

  p3 = nil
  v3 = nil
  (eye + 1...velocities.size).each do |i|
    next unless v1.independent?(velocities[i]) && v2.independent?(velocities[i])

    p3 = positions[i]
    v3 = velocities[i]
    break
  end

  rock = find_rock(p1, v1, p2, v2, p3, v3)
  puts rock
  rock.sum
end

def find_rock(p1, v1, p2, v2, p3, v3)
  a, p = find_plane(p1, v1, p2, v2)
  b, q = find_plane(p1, v1, p3, v3)
  c, r = find_plane(p2, v2, p3, v3)

  rock_vel = lin(p, b.cross(c), q, c.cross(a), r, a.cross(b))
  box_product = a.dot(b.cross(c))
  rock_vel = Vector[(rock_vel[0] / box_product).round, (rock_vel[1] / box_product).round, (rock_vel[2] / box_product).round]

  adjusted_v1 = v1 - rock_vel
  adjusted_v2 = v2 - rock_vel
  adjusted_vs_cross = adjusted_v1.cross(adjusted_v2)

  e = adjusted_vs_cross.dot(p2.cross(adjusted_v2))
  f = adjusted_vs_cross.dot(p1.cross(adjusted_v1))
  g = p1.dot(adjusted_vs_cross)
  s = adjusted_vs_cross.dot(adjusted_vs_cross)

  rock = lin(e, adjusted_v1, -f, adjusted_v2, g, adjusted_vs_cross)
  rock.map { |coordinate| coordinate / s }
end

def find_plane(p1, v1, p2, v2)
  pos_diff = p1 - p2
  vel_diff = v1 - v2
  vel_cross = v1.cross(v2)
  [pos_diff.cross(vel_diff), pos_diff.dot(vel_cross)]
end

def lin(p, a, q, b, r, c)
  x = p * a[0] + q * b[0] + r * c[0]
  y = p * a[1] + q * b[1] + r * c[1]
  z = p * a[2] + q * b[2] + r * c[2]
  Vector[x, y, z]
end

main
