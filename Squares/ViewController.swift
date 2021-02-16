//
//  ViewController.swift
//  Squares
//
//  Created by Gregg Jaskiewicz on 08/02/2021.
//

import Cocoa
import AppKit

class ViewController: NSViewController {

    @IBOutlet var squaresView: SquaresView!
    @IBOutlet var playPauseButton: NSButton!

    private var timer: Timer?
    private static let edgeSize: UInt = 100
    private var gol: GameOfLife = GameOfLife(boardSize: ViewController.edgeSize, populationPercentage: 50)

    private func randomProvider() -> [[NSColor]] {
        let edgeSize = ViewController.edgeSize
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

    private func provider() -> [[NSColor]] {
        var grid: [[NSColor]] = []

        let gameOfLifeGrid = self.gol.currentBoard()

        for golRow in gameOfLifeGrid {
            var row : [NSColor] = []
            for xPix in golRow {

                if xPix == true {
                    row.append(.black)
                } else {
                    row.append(.white)
                }
            }
            grid.append(row)
        }

        return grid
    }

    @IBAction func reset(_ sender: AnyObject) {
        self.gol =  GameOfLife(boardSize: ViewController.edgeSize, populationPercentage: 50)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.squaresView.xyGrid = self.provider()

        self.timer = Timer.scheduledTimer(withTimeInterval: 1/40,
                                          repeats: true,
                                          block: { [weak self] (_) in
                                            guard let strongSelf = self else {
                                                return
                                            }

                                            guard strongSelf.playPauseButton.state == .on else {
                                                return
                                            }

                                            strongSelf.gol.evaluate()
                                            strongSelf.squaresView.xyGrid = strongSelf.provider()
                                          })
    }

}
