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

final class Engine {
    let field: Core.Field<Player>

    private(set) var nextTurn: Player = .cross

    init(field: Core.Field<Player>) {
        self.field = field
    }

    func turn(x: Int, y: Int) throws {
        try field.put(.cross, at: .init(x: x, y: y))
        nextTurn = .zero
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

    func test_nextTurnWithValidCoordinatesAfterInit_changesNextTurnToZero() {
        let sut = makeSut()

        try! sut.turn(x: 0, y: 0)

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

    // MARK: - Helpers

    private func makeSut() -> Engine {
        let sut = Engine(field: Field(size: fieldSize)!)

        return sut
    }
}
