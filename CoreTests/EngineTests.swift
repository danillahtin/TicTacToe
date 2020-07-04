//
//  EngineTests.swift
//  CoreTests
//
//  Created by Danil Lahtin on 04.07.2020.
//  Copyright © 2020 Danil Lahtin. All rights reserved.
//

import XCTest
import Core

final class Engine {
    var nextTurn: Player { .cross }

    func turn(x: Int, y: Int) throws {
        throw NSError(domain: "akjshd", code: 0, userInfo: nil)
    }
}

final class EngineTests: XCTestCase {
    func test_init() {
        let _ = makeSut()
    }

    func test_init_nextTurnIsCross() {
        XCTAssertEqual(makeSut().nextTurn, .cross)
    }

    func test_nextTurnWithInvalidCoordinates_throws() {
        let sut = makeSut()

        XCTAssertThrowsError(try sut.turn(x: -1, y: -1))
    }

    // MARK: - Helpers

    private func makeSut() -> Engine {
        let sut = Engine()

        return sut
    }
}
