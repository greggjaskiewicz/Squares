//
//  SquaresView.swift
//  Squares
//
//  Created by Gregg Jaskiewicz on 08/02/2021.
//

import AppKit

final class SquaresView: NSView {

    var xyGrid: [[NSColor]] = [] {
        didSet {
            DispatchQueue.main.async {
                self.setNeedsDisplay(self.frame)
            }
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        let grid = self.xyGrid
        
        // if empty - don't bother
        guard grid.count > 0 else {
            return
        }
        let ySize = grid.first?.count ?? 0
        guard ySize > 0 else {
            return
        }
        
        // sizes
        let rectSize = CGSize(width: self.frame.width/CGFloat((grid.count)),
                              height: self.frame.height/CGFloat(ySize))
        
        for (x, row) in grid.enumerated() {
            for (y, column) in row.enumerated() {
                column.setFill()
                NSRect(x: CGFloat(x)*rectSize.width, y: CGFloat(y)*rectSize.height,
                       width: rectSize.width, height: rectSize.height).fill()
            }
        }

      }
}
