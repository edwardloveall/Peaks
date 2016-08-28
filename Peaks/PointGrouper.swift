struct PointPosition: Equatable {
  let x: Int
  let y: Int
}

func ==(lhs: PointPosition, rhs: PointPosition) -> Bool {
  return lhs.x == rhs.x && lhs.y == rhs.y
}

class PointGrouper {
  let points: [[Point]]
  var peaks = [PointPosition]()
  var groups = [[PointPosition]]()

  init(points: [[Point]]) {
    self.points = points
    for (y, col) in points.enumerate() {
      for (x, point) in col.enumerate() {
        if point.peak {
          let peak = PointPosition(x: x, y: y)
          peaks.append(peak)
        }
      }
    }
  }

  func groupPoints(above above: Double) -> [[PointPosition]] {
    groups = peaks.map { peak in
      fillPeak(peak)
    }
    return groups
  }

  func fillPeak(peak: PointPosition) -> [PointPosition] {
    var group = [PointPosition]()
    fill(peak.x, y: peak.y, group: &group)
    return group
  }

  func fill(x: Int, y: Int, inout group: [PointPosition]) {
    guard let col = points[safe: y], let point = col[safe: x] else { return }
    let position = PointPosition(x: x, y: y)
    if group.contains(position) { return }
    if point.height < 0.5 { return }

    group.append(position)

    fill(x + 1, y: y,     group: &group)
    fill(x - 1, y: y,     group: &group)
    fill(x,     y: y + 1, group: &group)
    fill(x,     y: y - 1, group: &group)
  }
}