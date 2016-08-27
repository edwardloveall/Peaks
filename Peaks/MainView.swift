//
//  MainView.swift
//  Peaks
//
//  Created by Edward Loveall on 8/27/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

class MainView: NSView {
  override func drawRect(dirtyRect: NSRect) {
    super.drawRect(dirtyRect)
    NSColor.redColor().setFill()
    NSBezierPath.fillRect(bounds)
  }
}
