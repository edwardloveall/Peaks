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
  var wrappers = [GroupWrapper]()
  var edges = [[Point]]()
  let heights = [
    [0,   0,    0,    0,   0],
    [0.4, 0.5,  0.55, 0.6, 0],
    [0,   0.65, 1,    0.7, 0, 0],
    [0,   0.8,  0.85, 0.9, 0],
    [0,   0,    0,    0,   0]
  ]
  var points = [[Point]]()
  var seed: Int32 = 0

  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
  }
  
  required init?(coder: NSCoder) {
    for (y, row) in heights.enumerate() {
      points.append([Point]())
      for (x, height) in row.enumerate() {
        points[y].append(Point(x: CGFloat(x), y: CGFloat(y), height: CGFloat(height)))
      }
    }

    if let int32Seed = Int32(Process.arguments[1]) {
      seed = int32Seed
    } else {
      let date = NSDate()
      let calendar = NSCalendar.currentCalendar()
      seed = Int32(calendar.component(.Nanosecond, fromDate: date))
      Swift.print("random seed: \(seed)")
    }
    super.init(coder: coder)
  }

  override func drawRect(dirtyRect: NSRect) {
    super.drawRect(dirtyRect)

    let landscape = LandscapeGenerator(bounds: bounds, tileSize: gridSize, seed: seed)
    points = landscape.generate()

    let finder = PeakFinder(points: points)
    finder.findPeaks()

    let grouper = PointGrouper(points: points)
    let groups = grouper.groupPoints(above: 0.5)

    for row in points {
      for point in row {
        let origin = CGPoint(x: point.x * gridSize.width,
                             y: point.y * gridSize.width)
        let rect = CGRect(origin: origin, size: gridSize)
        NSColor(calibratedWhite: point.height, alpha: 1).setFill()
        NSBezierPath.fillRect(rect)
      }
    }

    if wrappers.isEmpty {
      for group in groups {
        guard let wrapper = GroupWrapper(group: group) else { continue }
        wrappers.append(wrapper)
      }
    }

    for group in groups {
      let color = NSColor.blueColor()
      for row in group {
        for possiblePoint in row {
          guard let point = possiblePoint else { continue }
          let origin = CGPoint(x: point.x * gridSize.width,
                               y: point.y * gridSize.height)
          let rect = CGRect(origin: origin, size: gridSize)
          color.highlightWithLevel(point.height / 2)?.setFill()
          NSBezierPath.fillRect(rect)
        }
      }
    }

    for wrapper in wrappers {
      let color = NSColor.redColor()

      let edge = wrapper.wrap()
      for point in edge {
        color.highlightWithLevel(point.height)?.setFill()
        let origin = CGPoint(x: point.x * gridSize.width,
                             y: point.y * gridSize.width)
        let rect = CGRect(origin: origin, size: gridSize)
        NSBezierPath.fillRect(rect)
      }
    }
  }

  override func mouseDown(theEvent: NSEvent) {
    setNeedsDisplayInRect(bounds)
  }
}
