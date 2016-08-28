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

    let peakFinder = PeakFinder(points: points)
    peakFinder.findPeaks()

    for col in points {
      for point in col {
        let origin = CGPoint(x: point.x, y: point.y)
        let rect = CGRect(origin: origin, size: gridSize)
        if point.peak {
          NSColor(calibratedRed: CGFloat(point.height), green: 0, blue: 0, alpha: 1).setFill()
        } else {
          NSColor(calibratedWhite: CGFloat(point.height), alpha: 1).setFill()
        }
        NSBezierPath.fillRect(rect)
      }
    }
  }

  override func mouseDown(theEvent: NSEvent) {
    setNeedsDisplayInRect(bounds)
  }
}
