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
    for (index, peak) in peaks.enumerate() {
      fillPeak(peak, forPeakIndex: index)
    }
    return groups
  }

  func fillPeak(peak: PointPosition, forPeakIndex index: Int) {
    groups.append([PointPosition]())
    fill(peak.x, y: peak.y, groupIndex: index)
  }

  func fill(x: Int, y: Int, groupIndex index: Int) {
    guard let col = points[safe: y], let point = col[safe: x] else { return }
    let position = PointPosition(x: x, y: y)
    if groups[index].contains(position) { return }
    if point.height < 0.5 { return }

    groups[index].append(position)

    fill(x + 1, y: y,     groupIndex: index)
    fill(x - 1, y: y,     groupIndex: index)
    fill(x,     y: y + 1, groupIndex: index)
    fill(x,     y: y - 1, groupIndex: index)
  }
}