import CoreGraphics

class GroupWrapper {
  let group: [[Point?]]
  var startIndex: (x: Int, y: Int)
  let directions = [
    (x: 0,  y: 1),
    (x: -1, y: 1),
    (x: -1, y: 0),
    (x: -1, y: -1),
    (x: 0,  y: -1),
    (x: 1,  y: -1),
    (x: 1,  y: 0),
    (x: 1,  y: 1)
  ]
  var outerPoints: [Point]
  var currentIndex: (x: Int, y: Int)
  var directionIndex: Int
  var direction: (x: Int, y: Int)

  init?(group: [[Point?]]) {
    self.group = group
    let flatGroup = group.flatten().flatMap({ $0 })
    if flatGroup.isEmpty { return nil }
    let firstColumn = group[0]
    var y = 0
    for (index, point) in firstColumn.enumerate() {
      guard let _ = point else { continue }
      y = index
      break
    }
    startIndex = (x: 0, y: y)

    outerPoints = [Point]()
    currentIndex = startIndex
    directionIndex = 0
    direction = (x: 0, y: 0)
  }

  func wrap() -> [Point] {
    while currentIndex != startIndex || outerPoints.isEmpty {
      direction = directions[directionIndex % directions.count]
      currentIndex = (x: currentIndex.x + direction.x,
                      y: currentIndex.y + direction.y)
      guard
        let col = group[safe: currentIndex.y],
        let optional_neighbor = col[safe: currentIndex.x],
        let neighbor = optional_neighbor
      else {
        directionIndex += 1
        continue
      }

      outerPoints.append(neighbor)

      directionIndex += 6
      return outerPoints
    }
    return outerPoints
  }

  func slope(from firstPoint: Point, to secondPoint: Point) -> CGFloat {
    let dx = secondPoint.x - firstPoint.x
    let dy = secondPoint.y - firstPoint.y
    return atan(dy / dx)
  }
}
