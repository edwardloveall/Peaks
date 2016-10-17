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
  var outerPoints = [Point]()
  var currentEdgeIndex: (x: Int, y: Int)
  var directionIndex: Int
  var direction: (x: Int, y: Int)

  init?(group: [[Point?]]) {
    self.group = group
    let flatGroup = group.flatten().flatMap({ $0 })
    if flatGroup.isEmpty { return nil }
    var leftestPointX = CGFloat.infinity
    var leftestColumnIndex = Int.max

    for row in group {
      for (xIndex, point) in row.enumerate() {
        if let point = point {
          if point.x < leftestPointX {
            leftestPointX = point.x
            leftestColumnIndex = xIndex
          }
        }
      }
    }

    let leftColumnPoints = flatGroup.filter { $0.x == leftestPointX }
    var topPointIndexInLeftestColumn = 0
    for (index, _) in leftColumnPoints.enumerate() {
      if index > topPointIndexInLeftestColumn {
        topPointIndexInLeftestColumn = index
      }
    }

    startIndex = (x: leftestColumnIndex, y: topPointIndexInLeftestColumn)
    currentEdgeIndex = startIndex
    directionIndex = 0
    direction = (x: 0, y: 0)
    guard let startPoint = group[startIndex.y][startIndex.x] else {
      return nil
    }
    outerPoints.append(startPoint)
  }

  func wrap() -> [Point] {
    while true {
      direction = directions[directionIndex % directions.count]
      let possibleEdge = (x: currentEdgeIndex.x + direction.x,
                          y: currentEdgeIndex.y + direction.y)
      if possibleEdge == startIndex { break }
      guard
        let row = group[safe: possibleEdge.y],
        let optional_neighbor = row[safe: possibleEdge.x],
        let neighbor = optional_neighbor
      else {
        directionIndex += 1
        continue
      }

      outerPoints.append(neighbor)
      currentEdgeIndex = possibleEdge

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
