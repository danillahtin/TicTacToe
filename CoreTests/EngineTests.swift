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
    var nextTurn: Player { .cross }

    func turn(x: Int, y: Int) throws {
        throw Field.Error.invalidCoordinate
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

    // MARK: - Helpers

    private func makeSut() -> Engine {
        let sut = Engine()

        return sut
    }
}
