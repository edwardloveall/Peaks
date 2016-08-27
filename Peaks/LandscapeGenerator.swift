import AppKit

class LandscapeGenerator {
  let bounds: CGRect
  let tileSize: CGSize
  let noiseScale: Float = 0.01
  let xPoints: Int
  let yPoints: Int
  var points = [[Point]]()

  init(bounds: CGRect, tileSize: Int) {
    self.bounds = bounds
    self.tileSize = CGSize(width: tileSize, height: tileSize)
    self.xPoints = Int(bounds.width / CGFloat(tileSize))
    self.yPoints = Int(bounds.height / CGFloat(tileSize))
    setup()
  }

  func setup() {
    let perlin = PerlinGenerator()
    perlin.octaves = 4
    for y in 0..<yPoints {
      points.append([Point]())
      for x in 0..<xPoints {
        let floatX = Float(x)
        let floatY = Float(y)
        let height = perlin.perlinNoise(floatX * noiseScale,
                                        y: floatY * noiseScale,
                                        z: 0,
                                        t: 0) + 1 * 0.5
        let point = Point(x: x * Int(tileSize.width),
                         y: y * Int(tileSize.height),
                         height: height)
        points[y].append(point)
      }
    }
  }

  func draw() {
    for col in points {
      for point in col {
        let origin = CGPoint(x: point.x, y: point.y)
        let rect = CGRect(origin: origin, size: tileSize)
        NSColor(calibratedWhite: CGFloat(point.height), alpha: 1).setFill()
        NSBezierPath.fillRect(rect)
      }
    }
  }
}