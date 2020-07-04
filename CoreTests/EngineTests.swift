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

enum GameResult: Hashable {
    case win(Player)
    case tie
}

protocol EngineOutput {
    func didFinishGame(with result: GameResult)
}

final class WinStrategyStub {
    private var stub: Player?

    func set(winner: Player?) {
        self.stub = winner
    }

    func getWinner() -> Player? {
        stub
    }
}

final class Engine {
    let field: Core.Field<Player>
    let winStrategy: WinStrategyStub
    let output: EngineOutput

    private(set) var nextTurn: Player = .cross

    init(
        field: Core.Field<Player>,
        winStrategy: WinStrategyStub,
        output: EngineOutput)
    {
        self.field = field
        self.winStrategy = winStrategy
        self.output = output
    }

    func turn(x: Int, y: Int) throws {
        try field.put(.cross, at: .init(x: x, y: y))

        if let winner = winStrategy.getWinner() {
            output.didFinishGame(with: .win(winner))
        }

        if !field.hasCoordinateAvailable() {
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

    // MARK: - Helpers

    private func makeSut(
        winStrategy: WinStrategyStub = .init(),
        engineOutput: EngineOutputSpy = .init()) -> Engine
    {
        let sut = Engine(
            field: Field(size: fieldSize)!,
            winStrategy: winStrategy,
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
