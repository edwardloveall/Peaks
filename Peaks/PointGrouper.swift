import Cocoa

class PointGrouper {
  let points: [[Point]]
  var peaks = [Point]()
  var groups = [[[Point?]]]()

  init(points: [[Point]]) {
    self.points = points
    self.peaks = self.points.flatten().filter {
      $0.peak
    }
  }

  func groupPoints(above above: Double) -> [[[Point?]]] {
    for peak in peaks {
      if peak.grouped {
        continue
      }
      let pointList = fillPeak(peak)
      let group = arrangeWithPadding(pointList)
      groups.append(group)
    }
    return groups
  }

  func fillPeak(peak: Point) -> [Point] {
    var pointList = [Point]()
    var pointQueue = [Point]()
    pointQueue.append(peak)

    while !pointQueue.isEmpty {
      let point = pointQueue.removeFirst()
      if point.height < 0.5 { continue }
      if point.grouped { continue }
      let x = Int(point.x)
      let y = Int(point.y)
      pointList.append(point)
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

    return pointList
  }

  func arrangeWithPadding(group: [Point]) -> [[Point?]] {
    let limits = groupFrame(group)
    let height = Int(limits.height) + 1
    let width = Int(limits.width) + 1
    let row = Array<Point?>(count: width, repeatedValue: .None)
    var arrangedGroup = [[Point?]](count: height, repeatedValue: row)

    for point in group {
      let x = Int(point.x - limits.minX)
      let y = Int(point.y - limits.minY)
      arrangedGroup[y][x] = point
    }

    return arrangedGroup
  }

  func groupFrame(group: [Point]) -> NSRect {
    var minX = CGFloat.infinity
    var minY = CGFloat.infinity
    var maxX = -CGFloat.infinity
    var maxY = -CGFloat.infinity

    for point in group {
      if point.x < minX { minX = point.x }
      if point.y < minY { minY = point.y }
      if point.x > maxX { maxX = point.x }
      if point.y > maxY { maxY = point.y }
    }

    let width = maxX - minX
    let height = maxY - minY

    return CGRect(x: minX, y: minY, width: width, height: height)
  }
}
