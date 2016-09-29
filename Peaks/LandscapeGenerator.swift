import AppKit
import GameplayKit

class LandscapeGenerator {
  let bounds: CGRect
  let tileSize: CGSize
  let noiseScale: Float = 0.01
  let size: int2
  var points = [[Point]]()
  let seed: Int32

  init(bounds: CGRect, tileSize: CGSize, seed: Int32) {
    self.bounds = bounds
    self.tileSize = tileSize
    self.size = int2(
      Int32(bounds.width / tileSize.width),
      Int32(bounds.height / tileSize.height)
    )
    self.seed = seed
  }

  func generate() -> [[Point]] {
    let source = GKPerlinNoiseSource(
      frequency: 1,
      octaveCount: 4,
      persistence: 0.8,
      lacunarity: 2,
      seed: seed
    )
    let random = GKNoise(noiseSource: source)
    let perlinMap = GKNoiseMap(
      noise: random,
      size: double2(1.0, 1.0),
      origin: double2(1.0, 1.0),
      sampleCount: size,
      seamless: false
    )

    for y in 0..<size.y {
      points.append([Point]())
      for x in 0..<size.x {
        let cgx = CGFloat(x)
        let cgy = CGFloat(y)
        let intY = Int(y)
        let height = perlinMap.valueAtPosition(int2(x, y))
        let scaledHeight = CGFloat((height + 1.1) / 2.2)
        let point = Point(x: cgx, y: cgy, height: scaledHeight)
        points[intY].append(point)
      }
    }

    return points
  }
}
