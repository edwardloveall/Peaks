import AppKit

class LandscapeGenerator {
  let bounds: CGRect
  let tileSize: CGSize
  let noiseScale: Float = 0.01
  let xPoints: Int
  let yPoints: Int
  var points = [[Point]]()

  init(bounds: CGRect, tileSize: CGSize) {
    self.bounds = bounds
    self.tileSize = tileSize
    self.xPoints = Int(bounds.width / tileSize.width)
    self.yPoints = Int(bounds.height / tileSize.height)
  }

  func generate() -> [[Point]] {
    let perlin = PerlinGenerator()
    perlin.octaves = 4
    for y in 0..<yPoints {
      points.append([Point]())
      for x in 0..<xPoints {
        let floatX = Float(x)
        let floatY = Float(y)
        let cgx = CGFloat(x)
        let cgy = CGFloat(y)
        let height = perlin.perlinNoise(floatX * noiseScale,
                                        y: floatY * noiseScale,
                                        z: 0,
                                        t: 0)
        let scaledHeight = CGFloat((height + 1.1) / 2.2)
        let point = Point(x: cgx, y: cgy, height: scaledHeight)
        points[y].append(point)
      }
    }

    return points
  }
}
