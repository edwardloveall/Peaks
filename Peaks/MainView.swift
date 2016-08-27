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

    for col in points {
      for point in col {
        let origin = CGPoint(x: point.x, y: point.y)
        let rect = CGRect(origin: origin, size: gridSize)
        NSColor(calibratedWhite: CGFloat(point.height), alpha: 1).setFill()
        NSBezierPath.fillRect(rect)
      }
    }
  }

  override func mouseDown(theEvent: NSEvent) {
    let landscape = LandscapeGenerator(bounds: bounds, tileSize: gridSize)
    points = landscape.generate()
    setNeedsDisplayInRect(bounds)
  }
}
