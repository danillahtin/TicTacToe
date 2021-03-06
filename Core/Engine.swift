//
//  Engine.swift
//  Core
//
//  Created by Danil Lahtin on 04.07.2020.
//  Copyright © 2020 Danil Lahtin. All rights reserved.
//

public final class Engine {
    public enum Error: Swift.Error {
        case gameIsOver
    }

    private let field: Field<Player>
    private let gameRules: GameRules
    private let output: EngineOutput
    private var isFinished = false
    private var nextTurn: Player = .cross

    public init(
        field: Field<Player>,
        gameRules: GameRules,
        output: EngineOutput)
    {
        self.field = field
        self.gameRules = gameRules
        self.output = output
    }

    public func turn(x: Int, y: Int) throws {
        try checkIsFinished()
        try putNextTurn(x: x, y: y)

        if checkHasWinner() { return }

        checkCoordinateAvailable()
        switchNextTurn()
    }

    private func checkIsFinished() throws {
        guard isFinished else {
            return
        }

        throw Error.gameIsOver
    }

    private func putNextTurn(x: Int, y: Int) throws {
        try field.put(nextTurn, at: .init(x: x, y: y))
    }

    private func checkHasWinner() -> Bool {
        guard let winner = gameRules.getWinner() else {
            return false
        }

        isFinished = true
        output.didFinishGame(with: .win(winner))

        return true
    }

    private func checkCoordinateAvailable() {
        guard !field.hasCoordinateAvailable() else {
            return
        }

        isFinished = true
        output.didFinishGame(with: .tie)
    }

    private func switchNextTurn() {
        switch nextTurn {
        case .cross:
            nextTurn = .zero
        case .zero:
            nextTurn = .cross
        }
    }
}
