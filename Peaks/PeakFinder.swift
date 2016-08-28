import AppKit

class PeakFinder {
  let points: [[Point]]

  init(points: [[Point]]) {
    self.points = points
  }

  func findPeaks() {
    for (y, col) in points.enumerate() {
      for (x, point) in col.enumerate() {
        if isPeakAt(x, y: y) {
          point.peak = true
        }
      }
    }
  }

  func isPeakAt(x: Int, y: Int) -> Bool {
    let point = points[y][x]

    for colIndex in (y - 1...y + 1) {
      for rowIndex in (x - 1...x + 1) {
        guard
          let row = points[safe: colIndex],
          let other = row[safe: rowIndex]
        else {
          continue
        }

        if other.height > point.height {
          return false
        }
      }
    }

    return true
  }
}
