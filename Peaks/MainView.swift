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
    super.drawRect(dirtyRect)
    let landscape = LandscapeGenerator(bounds: bounds, tileSize: gridSize)
    points = landscape.generate()

    let finder = PeakFinder(points: points)
    finder.findPeaks()

    let grouper = PointGrouper(points: points)
    let groups = grouper.groupPoints(above: 0.5)

    for col in points {
      for point in col {
        let origin = CGPoint(x: point.x, y: point.y)
        let rect = CGRect(origin: origin, size: gridSize)
        NSColor(calibratedWhite: CGFloat(point.height), alpha: 1).setFill()
        NSBezierPath.fillRect(rect)
      }
    }

    for group in groups {
      let color = NSColor(calibratedHue: CGFloat.random(), saturation: 1, brightness: 0.5, alpha: 1)
      for position in group {
        let point = points[position.y][position.x]
        color.highlightWithLevel(CGFloat(point.height))?.setFill()
        let origin = CGPoint(x: point.x, y: point.y)
        let rect = CGRect(origin: origin, size: gridSize)
        NSBezierPath.fillRect(rect)
      }
    }
  }

  override func mouseDown(theEvent: NSEvent) {
    setNeedsDisplayInRect(bounds)
  }
}
