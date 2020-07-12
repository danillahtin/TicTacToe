//
//  DefaultGameRulesTests.swift
//  CoreTests
//
//  Created by Danil Lahtin on 12.07.2020.
//  Copyright © 2020 Danil Lahtin. All rights reserved.
//

import XCTest
import Core

private typealias Field = Core.Field<Player>

final class DefaultGameRules {
    func getWinner() -> Player? {
        nil
    }
}

final class DefaultGameRulesTests: XCTestCase {
    func test_init() {
        let _ = makeSut()
    }

    func test_getWinner_returnsNilWhenFieldIsEmpty() {
        let field = makeField()
        let sut = makeSut(field: field)

        XCTAssertNil(sut.getWinner())
    }

    // MARK: - Helpers

    private func makeSut(field: Field? = nil) -> DefaultGameRules {
        DefaultGameRules()
    }

    private func makeField() -> Field {
        Field(size: 3)!
    }
}
