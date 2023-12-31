Hail = Struct.new(:px, :py, :pz, :vx, :vy, :vz)
UPPER = 400_000_000_000_000
LOWER = 200_000_000_000_000

def main
  hailstones = []
  File.foreach('input.txt', chomp: true) do |line|
    px, py, pz, vx, vy, vz = line.split(/[\s,@]/).reject(&:empty?).map(&:to_f)
    hailstones << Hail.new(px, py, pz, vx, vy, vz)
  end
  total = 0
  (0...hailstones.size).each do |i|
    (i + 1 ...hailstones.size).each do |j|
      total += find_intersection(hailstones[i], hailstones[j])
    end
  end
  puts total
end

def find_intersection(line_ab, line_cd)
  puts line_ab, line_cd

  a1 = line_ab.vy
  b1 = -line_ab.vx
  c1 = a1 * line_ab.px + b1 * line_ab.py

  a2 = line_cd.vy
  b2 = -line_cd.vx
  c2 = a2 * line_cd.px + b2 * line_cd.py

  determinant = a1 * b2 - a2 * b1

  return 0 if determinant.zero?

  x = (b2 * c1 - b1 * c2) / determinant
  y = (a1 * c2 - a2 * c1) / determinant

  if in_bounds?([x, y], LOWER, UPPER) && in_future?([x, y], [line_ab, line_cd])
    puts [x, y].inspect
    return 1
  end

  0
end

def in_future?(coordinate, lines)
  cx, cy = coordinate
  lines.all? do |line|
    x = line.px
    vx = line.vx
    y = line.py
    vy = line.vy

    x_cond = (cx > x && vx.positive?) || (x > cx && vx.negative?)
    y_cond = (cy > y && vy.positive?) || (y > cy && vy.negative?)

    [x_cond, y_cond].all?
  end
end

def in_bounds?(coordinate, lower, upper)
  x, y = coordinate
  (lower..upper).include?(x) && (lower..upper).include?(y)
end

main
