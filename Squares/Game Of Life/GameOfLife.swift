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
    private var boardSize: UInt

    init(boardSize: UInt, populationPercentage: UInt8) {

        self.boardSize = boardSize
        for _ in 0..<boardSize {
            var row: [GameOfLifeCell] = []
            for _ in 0..<boardSize {
                let chance = arc4random_uniform(100)
                if chance < populationPercentage {
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


        for (y, row) in self.board.enumerated() {

            for (x, cell) in row.enumerated() {
                if (cell.state == .willDie)
                {
                    self.board[x][y] = GameOfLifeCell(state: .dead)
                }

                if (cell.state == .willRevive)
                {
                    self.board[x][y] = GameOfLifeCell(state: .alive)
                }
            }
        }

        for (y, row) in self.board.enumerated() {

            // pix
            for (x, cell) in row.enumerated() {

                var neighbours: [GameOfLifeCell] = []
                // row

                // X Bounds
                var prevIndex = -1
                if (x == 0) {
                    prevIndex = 0
                }

                var nextIndex = 1
                if (x == row.count-1) {
                    nextIndex = 0
                }

                // Y Bounds
                if y != 0 {
                    neighbours.append(contentsOf: self.board[y-1][(x+prevIndex)...(x+nextIndex)])
                }

                neighbours.append(contentsOf: row[(x+prevIndex)...(x+nextIndex)])

                if y != self.board.count-1 {
                    neighbours.append(contentsOf: self.board[y+1][(x+prevIndex)...(x+nextIndex)])
                }

                let neighboursCount = neighbours.compactMap({ ($0.state == .alive) ? 1 : 0 }).reduce(0, +)

                if cell.state == .alive {
                    if neighboursCount < 2 {
                        self.board[x][y] = GameOfLifeCell(state: .willDie)
                    }

                    if neighboursCount > 3 {
                        self.board[x][y] = GameOfLifeCell(state: .willDie)
                    }
                } else {
                    if neighboursCount == 3 {
                        self.board[x][y] = GameOfLifeCell(state: .willRevive)
                    }
                }

            }
        }
    }

    // 2d array with pixels
    public func currentBoard() -> [[Bool]] {

        var drawBoard: [[Bool]] = []

        for row in self.board {
            var drawRow: [Bool] = []
            // pix
            for cell in row {
                drawRow.append(cell.state == .alive)
            }
            drawBoard.append(drawRow)
        }

        return drawBoard
    }
}
