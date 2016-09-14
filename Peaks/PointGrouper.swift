import Cocoa

class PointGrouper {
  let points: [[Point]]
  var peaks = [Point]()
  var groups = [[Point]]()

  init(points: [[Point]]) {
    self.points = points
    self.peaks = self.points.flatten().filter {
      $0.peak
    }
  }

  func groupPoints(above above: Double) -> [[Point]] {
    for peak in peaks {
      if peak.grouped {
        continue
      }
      fillPeak(peak, forPeakIndex: groups.endIndex)
    }
    return groups
  }

  func fillPeak(peak: Point, forPeakIndex index: Int) {
    groups.append([Point]())
    fill(x: peak.x, y: peak.y, groupIndex: index)
  }

  func fill(x cgx: CGFloat, y cgy: CGFloat, groupIndex index: Int) {
    var pointQueue = [Point]()

    var x = Int(cgx)
    var y = Int(cgy)
    guard let col = points[safe: y], let point = col[safe: x] else { return }
    pointQueue.append(point)

    while !pointQueue.isEmpty {
      let point = pointQueue.removeFirst()
      if point.height < 0.5 { continue }
      if point.grouped { continue }
      x = Int(point.x)
      y = Int(point.y)
      groups[index].append(point)
      point.grouped = true

      if let rightCol = points[safe: y], let right = rightCol[safe: x + 1] {
        pointQueue.append(right)
      }

      if let leftCol = points[safe: y], let left = leftCol[safe: x - 1] {
        pointQueue.append(left)
      }

      if let upCol = points[safe: y + 1], let up = upCol[safe: x] {
        pointQueue.append(up)
      }

      if let downCol = points[safe: y - 1], let down = downCol[safe: x] {
        pointQueue.append(down)
      }
    }
  }
}
