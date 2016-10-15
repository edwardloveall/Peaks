import Cocoa

class Point: Equatable, CustomStringConvertible {
  let x: CGFloat
  let y: CGFloat
  let height: CGFloat
  var peak: Bool
  var grouped: Bool
  var description: String {
    return "(\(x), \(y)) \(height)"
  }

  init(x: CGFloat, y: CGFloat, height: CGFloat) {
    self.x = x
    self.y = y
    self.height = height
    self.peak = false
    self.grouped = false
  }
}

func ==(lhs: Point, rhs: Point) -> Bool {
  return lhs.x == rhs.x &&
         lhs.y == rhs.y &&
         lhs.height == rhs.height
}
