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

final class EngineTests: XCTestCase {
    private let fieldSize = 3

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

        XCTAssertEqual(sut.nextTurn, .cross)

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
        let gameRules = GameRulesStub()
        let engineOutput = EngineOutputSpy()
        let sut = makeSut(gameRules: gameRules, engineOutput: engineOutput)

        try! sut.turn(x: 0, y: 0)

        gameRules.set(winner: .cross)

        XCTAssertEqual(engineOutput.retrieved, [])

        try! sut.turn(x: 0, y: 2)

        XCTAssertEqual(engineOutput.retrieved, [.win(.cross)])
    }

    func test_anotherTurnsToWin_notifiesWin() {
        let gameRules = GameRulesStub()
        let engineOutput = EngineOutputSpy()
        let sut = makeSut(gameRules: gameRules, engineOutput: engineOutput)

        try! sut.turn(x: 1, y: 2)

        gameRules.set(winner: .zero)

        XCTAssertEqual(engineOutput.retrieved, [])

        try! sut.turn(x: 2, y: 2)

        XCTAssertEqual(engineOutput.retrieved, [.win(.zero)])
    }

    func test_fieldHasNoCoordinatesAvailableAndNoWinner_notifiesTie() {
        let gameRules = GameRulesStub()
        let engineOutput = EngineOutputSpy()
        let sut = makeSut(gameRules: gameRules, engineOutput: engineOutput)

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
        let gameRules = GameRulesStub()
        let engineOutput = EngineOutputSpy()
        let sut = makeSut(gameRules: gameRules, engineOutput: engineOutput)

        try! sut.turn(x: 0, y: 0)
        try! sut.turn(x: 0, y: 1)
        try! sut.turn(x: 0, y: 2)
        try! sut.turn(x: 1, y: 0)
        try! sut.turn(x: 1, y: 1)
        try! sut.turn(x: 1, y: 2)
        try! sut.turn(x: 2, y: 0)
        try! sut.turn(x: 2, y: 1)
        XCTAssertEqual(engineOutput.retrieved, [])

        gameRules.set(winner: .cross)
        try! sut.turn(x: 2, y: 2)

        XCTAssertEqual(engineOutput.retrieved, [.win(.cross)])
    }

    func test_takeTurnAfterWin_throwsGameIsOver() {
        let gameRules = GameRulesStub()
        let sut = makeSut(gameRules: gameRules)

        gameRules.set(winner: .zero)
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
        gameRules: GameRulesStub = .init(),
        engineOutput: EngineOutputSpy = .init()) -> Engine
    {
        let sut = Engine(
            field: Field(size: fieldSize)!,
            gameRules: gameRules,
            output: engineOutput)

        return sut
    }

    private final class EngineOutputSpy: EngineOutput {
        var retrieved: [GameResult] = []

        func didFinishGame(with result: GameResult) {
            retrieved.append(result)
        }
    }

    private final class GameRulesStub: GameRules {
        private var stub: Player?

        func set(winner: Player?) {
            self.stub = winner
        }

        func getWinner() -> Player? {
            stub
        }
    }
}
