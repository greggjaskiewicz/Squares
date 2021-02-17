//
//  GameOfLife.swift
//  Squares
//
//  Created by Gregg Jaskiewicz on 16/02/2021.
//

import Foundation

private struct GameOfLifeCell {
    enum CellState {
        case alive
        case willDie
        case willRevive
        case dead
    }

    var state: CellState
}

final class GameOfLife {

    private var board: [[GameOfLifeCell]] = []
    let boardSize: Int

    init(boardSize: Int, populationPercentage: UInt8) {

        self.boardSize = boardSize
        for _ in 0..<self.boardSize {
            var row: [GameOfLifeCell] = []
            for _ in 0..<self.boardSize {
                let chance = arc4random_uniform(100)
                if chance > populationPercentage {
                    row.append(GameOfLifeCell(state: .alive))
                } else {
                    row.append(GameOfLifeCell(state: .dead))
                }
            }
            self.board.append(row)
        }
    }

    // advance the state
    public func evaluate() {

        let previousBoard = self.board

        for y in 0..<self.boardSize {

            // pix
            for x in 0..<self.boardSize {
                var neighbours: [GameOfLifeCell] = []
                // row

                // X Bounds
                var prevIndex = -1
                if (x == 0) {
                    prevIndex = 0
                }

                var nextIndex = 1
                if (x+1 == self.boardSize) {
                    nextIndex = 0
                }

                prevIndex += x
                nextIndex += x

                // Y Bounds
                if y > 0 {
                    neighbours.append(contentsOf: previousBoard[y-1][(prevIndex)...(nextIndex)])
                }

                neighbours.append(contentsOf: previousBoard[y][(prevIndex)...(nextIndex)])

                if y+1 != self.boardSize {
                    neighbours.append(contentsOf: previousBoard[y+1][(prevIndex)...(nextIndex)])
                }

                let neighboursCount = neighbours.compactMap({ ($0.state == .alive) ? 1 : 0 }).reduce(0, +)

                if previousBoard[y][x].state == .alive {
                    if neighboursCount < 2 {
                        self.board[y][x].state = .willDie
                    }

                    if neighboursCount > 3 {
                        self.board[y][x].state = .willDie
                    }
                } else {
                    if neighboursCount == 3 {
                        self.board[y][x].state = .willRevive
                    }
                }

            }
        }

        let boardSnapshot = self.board

        for y in 0..<self.boardSize {
            for x in 0..<self.boardSize {
                if (boardSnapshot[y][x].state == .willDie)
                {
                    self.board[y][x].state = .dead
                }

                if (boardSnapshot[y][x].state == .willRevive)
                {
                    self.board[y][x].state = .alive
                }
            }
        }
    }

    // 2d array with pixels
    public func currentBoard() -> [[Bool]] {

        var drawBoard: [[Bool]] = []

        for y in 0..<self.boardSize {
            var drawRow: [Bool] = []
            for x in 0..<self.boardSize {
                drawRow.append(self.board[y][x].state == .alive)
            }
            drawBoard.append(drawRow)
        }

        return drawBoard
    }
}
