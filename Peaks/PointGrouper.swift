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
    for (index, peak) in peaks.enumerate() {
      fillPeak(peak, forPeakIndex: index)
    }
    return groups
  }

  func fillPeak(peak: Point, forPeakIndex index: Int) {
    groups.append([Point]())
    fill(x: peak.x, y: peak.y, groupIndex: index)
  }

  func fill(x cgx: CGFloat, y cgy: CGFloat, groupIndex index: Int) {
    let x = Int(cgx)
    let y = Int(cgy)
    guard let col = points[safe: y], let point = col[safe: x] else { return }
    if groups[index].contains(point) { return }
    if point.height < 0.5 { return }

    groups[index].append(point)

    fill(x: cgx + 1, y: cgy,     groupIndex: index)
    fill(x: cgx - 1, y: cgy,     groupIndex: index)
    fill(x: cgx,     y: cgy + 1, groupIndex: index)
    fill(x: cgx,     y: cgy - 1, groupIndex: index)
  }
}
