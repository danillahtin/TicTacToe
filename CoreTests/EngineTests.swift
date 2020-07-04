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
}

final class EngineTests: XCTestCase {
    func test_init() {
        let _ = makeSut()
    }

    func test_init_nextTurnIsCross() {
        XCTAssertEqual(makeSut().nextTurn, .cross)
    }

    // MARK: - Helpers

    private func makeSut() -> Engine {
        let sut = Engine()

        return sut
    }
}
