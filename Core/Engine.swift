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

    private let field: Core.Field<Player>
    private let gameRules: GameRules
    private let output: EngineOutput
    private var isFinished = false

    public private(set) var nextTurn: Player = .cross

    public init(
        field: Core.Field<Player>,
        gameRules: GameRules,
        output: EngineOutput)
    {
        self.field = field
        self.gameRules = gameRules
        self.output = output
    }

    public func turn(x: Int, y: Int) throws {
        if isFinished {
            throw Error.gameIsOver
        }

        try field.put(.cross, at: .init(x: x, y: y))

        if let winner = gameRules.getWinner() {
            isFinished = true
            output.didFinishGame(with: .win(winner))
            return
        }

        if !field.hasCoordinateAvailable() {
            isFinished = true
            output.didFinishGame(with: .tie)
        }

        switch nextTurn {
        case .cross:
            nextTurn = .zero
        case .zero:
            nextTurn = .cross
        }
    }
}
