import Foundation

public extension CGFloat {
  public static func random(min: CGFloat = 0, max: CGFloat = 1) -> CGFloat {
    let zeroToOne = CGFloat(arc4random()) / 0xFFFFFFFF
    return zeroToOne * (max - min) + min
  }
}
