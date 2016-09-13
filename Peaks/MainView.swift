//
//  MainView.swift
//  Peaks
//
//  Created by Edward Loveall on 8/27/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

class MainView: NSView {
  let gridSize: CGSize = CGSize(width: 10, height: 10)
  var points = [[Point]]()

  override func drawRect(dirtyRect: NSRect) {
    let t0 = NSDate.timeIntervalSinceReferenceDate()
    super.drawRect(dirtyRect)
    let landscape = LandscapeGenerator(bounds: bounds, tileSize: gridSize)
    points = landscape.generate()

    let finder = PeakFinder(points: points)
    finder.findPeaks()

    let grouper = PointGrouper(points: points)
    let groups = grouper.groupPoints(above: 0.5)

    for col in points {
      for point in col {
        let origin = CGPoint(x: point.x * gridSize.width,
                             y: point.y * gridSize.width)
        let rect = CGRect(origin: origin, size: gridSize)
        NSColor(calibratedWhite: point.height, alpha: 1).setFill()
        NSBezierPath.fillRect(rect)
      }
    }

    for group in groups {
      let color = NSColor(calibratedHue: CGFloat.random(), saturation: 1, brightness: 0.5, alpha: 1)
      for point in group {
        color.highlightWithLevel(point.height)?.setFill()
        let origin = CGPoint(x: point.x * gridSize.width,
                             y: point.y * gridSize.width)
        let rect = CGRect(origin: origin, size: gridSize)
        NSBezierPath.fillRect(rect)
      }
    }

    let t1 = NSDate.timeIntervalSinceReferenceDate()
    Swift.print(t1 - t0)
  }

  override func mouseDown(theEvent: NSEvent) {
    setNeedsDisplayInRect(bounds)
  }
}
