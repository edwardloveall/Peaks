import AppKit

class PeakFinder {
  let points: [[Point]]

  init(points: [[Point]]) {
    self.points = points
  }

  func findPeaks() {
    for (x, row) in points.enumerate() {
      for (y, point) in row.enumerate() {
        if isPeakAt(x, y: y) {
          point.peak = true
        }
      }
    }
  }

  func isPeakAt(x: Int, y: Int) -> Bool {
    let point = points[x][y]

    for rowIndex in (x - 1...x + 1) {
      for colIndex in (y - 1...y + 1) {
        guard
          let row = points[safe: rowIndex],
          let other = row[safe: colIndex]
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
