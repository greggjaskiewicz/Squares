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
                self.setNeedsDisplay(self.bounds)
            }
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {

        NSGraphicsContext.saveGraphicsState()

        guard let context = NSGraphicsContext.current?.cgContext else {
            return
        }

        let drawRect = self.frame

//        print("\(self.frame)")

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
        let rectSize = CGSize(width: drawRect.width/CGFloat(grid.count),
                              height: drawRect.height/CGFloat(ySize))

        for (x, row) in grid.enumerated() {
            for (y, column) in row.enumerated() {

                context.setFillColor(column.cgColor)
                let xPoint = (CGFloat(x)*rectSize.width)
                let yPoint = (CGFloat(y)*rectSize.height)
                let rect = NSRect(origin: CGPoint(x: xPoint, y: yPoint), size: rectSize)

                context.fill(rect)
            }
        }

        NSGraphicsContext.restoreGraphicsState()

    }
}
