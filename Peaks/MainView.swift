//
//  MainView.swift
//  Peaks
//
//  Created by Edward Loveall on 8/27/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

class MainView: NSView {
  let gridSize = 10

  override func drawRect(dirtyRect: NSRect) {
    super.drawRect(dirtyRect)
    LandscapeGenerator(bounds: bounds, tileSize: gridSize).draw()
  }
}
