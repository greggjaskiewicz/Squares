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

    private func evaluateRow(_ y: Int, previousBoard: [[GameOfLifeCell]]) -> [GameOfLifeCell] {

        var outputRow = previousBoard[y]

        for x in 0..<self.boardSize {
            var neighbours: [GameOfLifeCell] = []
            // row

            // X Bounds
            var prevIndex = -1
            if (y == 0) {
                prevIndex = 0
            }

            var nextIndex = 1
            if (y+1 == self.boardSize) {
                nextIndex = 0
            }

            prevIndex += y
            nextIndex += y

            let rows = previousBoard[(prevIndex)...(nextIndex)]

            var xPrevIndex = -1
            if (x == 0) {
                xPrevIndex = 0
            }

            var xNextIndex = 1
            if (x+1 == self.boardSize) {
                xNextIndex = 0
            }

            xPrevIndex += x
            xNextIndex += x

            for row in rows {
                neighbours.append(contentsOf: row[(xPrevIndex)...(xNextIndex)])
            }

            var neighboursCount = neighbours.compactMap({ ($0.state == .alive) ? 1 : 0 }).reduce(0, +)

            if previousBoard[y][x].state == .alive {
                neighboursCount -= 1
            }

            if previousBoard[y][x].state == .alive {
                if neighboursCount < 2 {
                    outputRow[x].state = .willDie
                }

                if neighboursCount > 3 {
                    outputRow[x].state = .willDie
                }
            } else {
                if neighboursCount == 3 {
                    outputRow[x].state = .willRevive
                }
            }
        }

        return outputRow
    }

    private let boardAccessQueue = DispatchQueue(label: "BoardAccessQueue")

    // advance the state
    public func evaluate() {

        var previousBoard: [[GameOfLifeCell]] = []

        self.boardAccessQueue.sync {
            previousBoard = self.board
        }
        let group = DispatchGroup()

        // wait ...
        group.wait()
        for y in 0..<self.boardSize {

            group.enter()

            var outputRow = previousBoard[y]
            DispatchQueue.global(qos: .userInitiated).async {
                outputRow = self.evaluateRow(y, previousBoard: previousBoard)
                self.boardAccessQueue.sync {
                    self.board[y] = outputRow
                }
                group.leave()
            }
        }

        group.wait()

        var newBoard: [[GameOfLifeCell]] = []
        var boardSnapshot: [[GameOfLifeCell]] = []

        self.boardAccessQueue.sync {
            newBoard = self.board
            boardSnapshot = self.board
        }

        for y in 0..<self.boardSize {
            for x in 0..<self.boardSize {

                if x < 2 {
                    let chance = arc4random_uniform(100)
                    if chance > 50 {
                        newBoard[y][x].state = .alive
                    }
                }

                if (boardSnapshot[y][x].state == .willDie)
                {
                    newBoard[y][x].state = .dead
                }

                if (boardSnapshot[y][x].state == .willRevive)
                {
                    newBoard[y][x].state = .alive
                }
            }
        }

        self.boardAccessQueue.sync {
            self.board = newBoard
        }
    }

    func addLife(to position: CGPoint) {

        guard position.x < CGFloat(self.boardSize) && position.y < CGFloat(self.boardSize) else {
            return
        }

        var evaulateBoard: [[GameOfLifeCell]] = []

        self.boardAccessQueue.sync {
            evaulateBoard = self.board
        }

        let size = 4

        for y in -(size)...(size) {
            for x in -(size-abs(y))..<(size-abs(y)) {
                let posX = Int(position.x)+x
                let posY = Int(position.y)+y
                if (posX > 0 && posY > 0 && posX < self.boardSize && posY < self.boardSize) {
                    (evaulateBoard[posX][posY]).state = .willRevive
                }
            }
        }


        self.boardAccessQueue.sync {
            self.board = evaulateBoard
        }
    }

    // 2d array with pixels
    public func currentBoard() -> [[Bool]] {

        var drawBoard: [[Bool]] = []

        var evaulateBoard: [[GameOfLifeCell]] = []

        self.boardAccessQueue.sync {
            evaulateBoard = self.board
        }
        
        self.boardAccessQueue.sync {
            for y in 0..<self.boardSize {
                var drawRow: [Bool] = []
                for x in 0..<self.boardSize {
                    drawRow.append(evaulateBoard[y][x].state == .alive)
                }
                drawBoard.append(drawRow)
            }
        }

        return drawBoard
    }
}
