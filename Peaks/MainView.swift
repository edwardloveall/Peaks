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
  var wrappers = [GroupWrapper]()
  var edges = [[Point]]()

  override func drawRect(dirtyRect: NSRect) {
    super.drawRect(dirtyRect)
    var seed: Int32

    if let int32Seed = Int32(Process.arguments[1]) {
      seed = int32Seed
    } else {
      let date = NSDate()
      let calendar = NSCalendar.currentCalendar()
      seed = Int32(calendar.component(.Nanosecond, fromDate: date))
      Swift.print("random seed: \(seed)")
    }

    let landscape = LandscapeGenerator(bounds: bounds, tileSize: gridSize, seed: seed)
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

    if wrappers.isEmpty {
      for group in groups {
        guard let wrapper = GroupWrapper(group: group) else { continue }
        wrappers.append(wrapper)
      }
    }

    for group in groups {
      let color = NSColor.blueColor()
      for col in group {
        for possiblePoint in col {
          guard let point = possiblePoint else { continue }
          let origin = CGPoint(x: point.x * gridSize.width,
                               y: point.y * gridSize.height)
          let rect = CGRect(origin: origin, size: gridSize)
          color.highlightWithLevel(point.height / 2)?.setFill()
          NSBezierPath.fillRect(rect)
        }
      }
    }

    for (index, wrapper) in wrappers.enumerate() {
      let color = NSColor(calibratedHue: CGFloat.random(), saturation: 1, brightness: 0.5, alpha: 1)

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
