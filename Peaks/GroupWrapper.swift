import CoreGraphics

class GroupWrapper {
  let group: [[Point?]]
  let startPoint: Point
  let directions = [
    (x: 0,  y: -1),
    (x: -1, y: -1),
    (x: -1, y: 0),
    (x: -1, y: 1),
    (x: 0,  y: 1),
    (x: 1,  y: 1),
    (x: 1,  y: 0),
    (x: 1,  y: -1)
  ]

  init?(group: [[Point?]]) {
    let flatGroup = group.flatten()
    self.group = group
    var candidatePoint = Point(x: CGFloat.infinity, y: CGFloat.infinity, height: 0)
    for point in flatGroup {
      guard let point = point else { continue }
      if point.x < candidatePoint.x {
        candidatePoint = point
      } else if point.y > candidatePoint.y {
        candidatePoint = point
      }
    }
    startPoint = candidatePoint
    if startPoint.x == CGFloat.infinity || startPoint.y == CGFloat.infinity {
      return nil
    }
  }

  func wrap() -> [Point] {
    var outerPoints = [Point]()
    var currentPoint = startPoint
    var x = Int(currentPoint.x)
    var y = Int(currentPoint.y)
    var directionIndex = directions.endIndex - 1
    var direction = directions[directionIndex]

    while currentPoint != startPoint || outerPoints.isEmpty {
      directionIndex += 1
      direction = directions[directionIndex % directions.count]
      guard
        let col = group[safe: x + direction.x],
        let optional_neighbor = col[safe: y + direction.y],
        let neighbor = optional_neighbor
        else {
          continue
      }

      outerPoints.append(neighbor)
      x = Int(neighbor.x)
      y = Int(neighbor.y)
      currentPoint = neighbor
    }
    return outerPoints
  }

  func slope(from firstPoint: Point, to secondPoint: Point) -> CGFloat {
    let dx = secondPoint.x - firstPoint.x
    let dy = secondPoint.y - firstPoint.y
    return atan(dy / dx)
  }
}

