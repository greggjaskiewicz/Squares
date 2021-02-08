//
//  ViewController.swift
//  Squares
//
//  Created by Gregg Jaskiewicz on 08/02/2021.
//

import Cocoa
import AppKit

class ViewController: NSViewController {

    private var squaresView: SquaresView?

    private var timer: Timer?

    // in an ideal world - this would be in a separate class
    private func provider() -> [[NSColor]] {
        let edgeSize = 50
        var grid: [[NSColor]] = []

        for _ in 0..<edgeSize {
            var row : [NSColor] = []
            for _ in 0..<edgeSize {
                let color = NSColor(red: CGFloat(arc4random_uniform(255))/255.0,
                                    green: CGFloat(arc4random_uniform(255))/255.0,
                                    blue: CGFloat(arc4random_uniform(255))/255.0,
                                    alpha: 1)
                row.append(color)
            }
            grid.append(row)
        }

        return grid
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let squaresView = SquaresView()
        self.view.addSubview(squaresView)
        self.squaresView = squaresView

        self.timer = Timer.scheduledTimer(withTimeInterval: 1/30,
                                          repeats: true,
                                          block: { (_) in
                                            self.squaresView?.xyGrid = self.provider()
                                          })
    }

    override func viewWillLayout() {
        super.viewWillLayout()
        self.squaresView?.frame = self.view.bounds
    }
}

