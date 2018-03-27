#! ruby -Ku
# coding: utf-8

require "rexml/document"

# Unknown_Pleasures_Vector.svg
# http://i.document.m05.de/2013/05/23/joy-divisions-unknown-pleasures-printed-in-3d/
f = File.read("./Unknown_Pleasures_Vector.svg")
d = REXML::Document.new(f)

r0 = []
d.elements.each("//path") do |e|
  v = e.attribute("d").value
  a = v.split(/\s*([mcl])\s+/)
  a.shift
  r0 << []
  while !a.empty?
    a0, a1 = a.shift(2)
    s = a1.split(/\s+/)
    case a0
    when "m", "l"
      r0.last.concat(s)
    when "c"
      i = (1..(s.length / 3)).map{|n| n * 3 - 1}
      r0.last.concat(s.values_at(*i))
    end
  end
end

r1 = []
r0.each do |s|
  a = s.map{|m0| m0.split(",").map{|m1| m1.to_f}}
  x = 0; y = a[0][1]
  r1 << []
  a.each do |v|
    x += v[0]; y -= v[1]
    r1.last << [x, y]
  end
end

r2 = []
r1.each do |l|
  i = 0
  r2 << []
  l.unshift([-10, l[0][1]])
  l.push([630, l[-1][1]])
  (0..620).step(2) do |x|
    while !(l[i][0] <= x && x < l[i + 1][0])
      i += 1
    end
    x0 = l[i][0]; y0 = l[i][1]
    x1 = l[i + 1][0]; y1 = l[i + 1][1]
    y = (y1 - y0) / (x1 - x0) * (x - x0) + y0
    r2.last << y
  end
end

r2 = r2.transpose
r2.each{|l| puts l.map{|v| sprintf("%.2f", v)}.join(",")}
