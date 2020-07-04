//
//  EngineTests.swift
//  CoreTests
//
//  Created by Danil Lahtin on 04.07.2020.
//  Copyright © 2020 Danil Lahtin. All rights reserved.
//

import XCTest
import Core

private typealias Field = Core.Field<Player>

final class WinStrategyStub: GameRules {
    private var stub: Player?

    func set(winner: Player?) {
        self.stub = winner
    }

    func getWinner() -> Player? {
        stub
    }
}

protocol GameRules {
    func getWinner() -> Player?
}

final class Engine {
    enum Error: Swift.Error {
        case gameIsOver
    }

    private let field: Core.Field<Player>
    private let gameRules: GameRules
    private let output: EngineOutput
    private var isFinished = false

    private(set) var nextTurn: Player = .cross

    init(
        field: Core.Field<Player>,
        gameRules: GameRules,
        output: EngineOutput)
    {
        self.field = field
        self.gameRules = gameRules
        self.output = output
    }

    func turn(x: Int, y: Int) throws {
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

final class EngineTests: XCTestCase {
    private let fieldSize = 3

    func test_init() {
        let _ = makeSut()
    }

    func test_init_nextTurnIsCross() {
        XCTAssertEqual(makeSut().nextTurn, .cross)
    }

    func test_nextTurnWithInvalidCoordinates_throwsInvalidCoordinateError() {
        let sut = makeSut()
        let invalidCoordinate = Field.Error.invalidCoordinate

        assert(throws: invalidCoordinate, when: { try sut.turn(x: -1, y: 0) })
        assert(throws: invalidCoordinate, when: { try sut.turn(x: 0, y: -1) })
        assert(throws: invalidCoordinate, when: { try sut.turn(x: -1, y: -1) })
        assert(throws: invalidCoordinate, when: { try sut.turn(x: fieldSize, y: 0) })
        assert(throws: invalidCoordinate, when: { try sut.turn(x: 0, y: fieldSize) })
        assert(throws: invalidCoordinate, when: { try sut.turn(x: fieldSize, y: fieldSize) })
    }

    func test_nextTurnWithValidCoordinates_changesNextTurn() {
        let sut = makeSut()

        try! sut.turn(x: 0, y: 0)
        XCTAssertEqual(sut.nextTurn, .zero)

        try! sut.turn(x: 1, y: 0)
        XCTAssertEqual(sut.nextTurn, .cross)

        try! sut.turn(x: 2, y: 0)
        XCTAssertEqual(sut.nextTurn, .zero)

        try! sut.turn(x: 0, y: 1)
        XCTAssertEqual(sut.nextTurn, .cross)

        try! sut.turn(x: 1, y: 1)
        XCTAssertEqual(sut.nextTurn, .zero)

        try! sut.turn(x: 2, y: 1)
        XCTAssertEqual(sut.nextTurn, .cross)

        try! sut.turn(x: 0, y: 2)
        XCTAssertEqual(sut.nextTurn, .zero)

        try! sut.turn(x: 1, y: 2)
        XCTAssertEqual(sut.nextTurn, .cross)

        try! sut.turn(x: 2, y: 2)
        XCTAssertEqual(sut.nextTurn, .zero)
    }

    func test_putValueAtOccupiedCoordinate_throwsCoordinateOccupiedError() {
        let sut = makeSut()
        let coordinateOccupied = Field.Error.coordinateOccupied

        try! sut.turn(x: 0, y: 0)
        assert(throws: coordinateOccupied, when: { try sut.turn(x: 0, y: 0) })
        assert(throws: coordinateOccupied, when: { try sut.turn(x: 0, y: 0) })

        try! sut.turn(x: 0, y: 1)
        assert(throws: coordinateOccupied, when: { try sut.turn(x: 0, y: 1) })
        assert(throws: coordinateOccupied, when: { try sut.turn(x: 0, y: 1) })

        try! sut.turn(x: 1, y: 0)
        assert(throws: coordinateOccupied, when: { try sut.turn(x: 1, y: 0) })
        assert(throws: coordinateOccupied, when: { try sut.turn(x: 1, y: 0) })
    }

    func test_turnsToWin_notifiesWin() {
        let winStrategy = WinStrategyStub()
        let engineOutput = EngineOutputSpy()
        let sut = makeSut(winStrategy: winStrategy, engineOutput: engineOutput)

        try! sut.turn(x: 0, y: 0)

        winStrategy.set(winner: .cross)

        XCTAssertEqual(engineOutput.retrieved, [])

        try! sut.turn(x: 0, y: 2)

        XCTAssertEqual(engineOutput.retrieved, [.win(.cross)])
    }

    func test_anotherTurnsToWin_notifiesWin() {
        let winStrategy = WinStrategyStub()
        let engineOutput = EngineOutputSpy()
        let sut = makeSut(winStrategy: winStrategy, engineOutput: engineOutput)

        try! sut.turn(x: 1, y: 2)

        winStrategy.set(winner: .zero)

        XCTAssertEqual(engineOutput.retrieved, [])

        try! sut.turn(x: 2, y: 2)

        XCTAssertEqual(engineOutput.retrieved, [.win(.zero)])
    }

    func test_fieldHasNoCoordinatesAvailableAndNoWinner_notifiesTie() {
        let winStrategy = WinStrategyStub()
        let engineOutput = EngineOutputSpy()
        let sut = makeSut(winStrategy: winStrategy, engineOutput: engineOutput)

        try! sut.turn(x: 0, y: 0)
        try! sut.turn(x: 0, y: 1)
        try! sut.turn(x: 0, y: 2)
        try! sut.turn(x: 1, y: 0)
        try! sut.turn(x: 1, y: 1)
        try! sut.turn(x: 1, y: 2)
        try! sut.turn(x: 2, y: 0)
        try! sut.turn(x: 2, y: 1)
        XCTAssertEqual(engineOutput.retrieved, [])

        try! sut.turn(x: 2, y: 2)

        XCTAssertEqual(engineOutput.retrieved, [.tie])
    }

    func test_winAndFieldHasNoCoordinatesAvailable_notifiesWin() {
        let winStrategy = WinStrategyStub()
        let engineOutput = EngineOutputSpy()
        let sut = makeSut(winStrategy: winStrategy, engineOutput: engineOutput)

        try! sut.turn(x: 0, y: 0)
        try! sut.turn(x: 0, y: 1)
        try! sut.turn(x: 0, y: 2)
        try! sut.turn(x: 1, y: 0)
        try! sut.turn(x: 1, y: 1)
        try! sut.turn(x: 1, y: 2)
        try! sut.turn(x: 2, y: 0)
        try! sut.turn(x: 2, y: 1)
        XCTAssertEqual(engineOutput.retrieved, [])

        winStrategy.set(winner: .cross)
        try! sut.turn(x: 2, y: 2)

        XCTAssertEqual(engineOutput.retrieved, [.win(.cross)])
    }

    func test_takeTurnAfterWin_throwsGameIsOver() {
        let winStrategy = WinStrategyStub()
        let sut = makeSut(winStrategy: winStrategy)

        winStrategy.set(winner: .zero)
        try! sut.turn(x: 0, y: 0)

        assert(throws: Engine.Error.gameIsOver, when: { try sut.turn(x: 0, y: 0)})
        assert(throws: Engine.Error.gameIsOver, when: { try sut.turn(x: 0, y: 1)})
        assert(throws: Engine.Error.gameIsOver, when: { try sut.turn(x: 1, y: 1)})
    }

    func test_takeTurnAfterTie_throwsGameIsOver() {
        let sut = makeSut()

        try! sut.turn(x: 0, y: 0)
        try! sut.turn(x: 0, y: 1)
        try! sut.turn(x: 0, y: 2)
        try! sut.turn(x: 1, y: 0)
        try! sut.turn(x: 1, y: 1)
        try! sut.turn(x: 1, y: 2)
        try! sut.turn(x: 2, y: 0)
        try! sut.turn(x: 2, y: 1)
        try! sut.turn(x: 2, y: 2)

        assert(throws: Engine.Error.gameIsOver, when: { try sut.turn(x: 0, y: 0)})
        assert(throws: Engine.Error.gameIsOver, when: { try sut.turn(x: 0, y: 1)})
        assert(throws: Engine.Error.gameIsOver, when: { try sut.turn(x: 1, y: 1)})
    }

    // MARK: - Helpers

    private func makeSut(
        winStrategy: WinStrategyStub = .init(),
        engineOutput: EngineOutputSpy = .init()) -> Engine
    {
        let sut = Engine(
            field: Field(size: fieldSize)!,
            gameRules: winStrategy,
            output: engineOutput)

        return sut
    }

    private final class EngineOutputSpy: EngineOutput {
        var retrieved: [GameResult] = []

        func didFinishGame(with result: GameResult) {
            retrieved.append(result)
        }
    }
}
