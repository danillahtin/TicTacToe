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
    let field: Core.Field<Player>
    let winCoordinates: [[Core.Field<Player>.Coordinate]]

    init(
        field: Core.Field<Player>,
        winCoordinates: [[Core.Field<Player>.Coordinate]])
    {
        self.field = field
        self.winCoordinates = winCoordinates
    }

    static var winCoordinates: [[Core.Field<Player>.Coordinate]] {
        [
            [
                Field.Coordinate(x: 0, y: 0),
                Field.Coordinate(x: 0, y: 1),
                Field.Coordinate(x: 0, y: 2),
            ],
            [
                Field.Coordinate(x: 1, y: 0),
                Field.Coordinate(x: 1, y: 1),
                Field.Coordinate(x: 1, y: 2),
            ],
            [
                Field.Coordinate(x: 2, y: 0),
                Field.Coordinate(x: 2, y: 1),
                Field.Coordinate(x: 2, y: 2),
            ],
            [
                Field.Coordinate(x: 0, y: 0),
                Field.Coordinate(x: 1, y: 0),
                Field.Coordinate(x: 2, y: 0),
            ],
            [
                Field.Coordinate(x: 0, y: 1),
                Field.Coordinate(x: 1, y: 1),
                Field.Coordinate(x: 2, y: 1),
            ],
            [
                Field.Coordinate(x: 0, y: 2),
                Field.Coordinate(x: 1, y: 2),
                Field.Coordinate(x: 2, y: 2),
            ],
            [
                Field.Coordinate(x: 0, y: 0),
                Field.Coordinate(x: 1, y: 1),
                Field.Coordinate(x: 2, y: 2),
            ],
            [
                Field.Coordinate(x: 2, y: 0),
                Field.Coordinate(x: 1, y: 1),
                Field.Coordinate(x: 0, y: 2),
            ],
        ]
    }

    func getWinner() -> Player? {
        winCoordinates.lazy.compactMap(winner).first
    }

    private func winner(for coordinates: [Field.Coordinate]) -> Player? {
        let candidate = coordinates.first.flatMap(player)

        for coordinate in coordinates {
            if try! field.value(at: coordinate) != candidate {
                return nil
            }
        }

        return candidate
    }

    private func player(at coordinate: Field.Coordinate) -> Player? {
        try! field.value(at: coordinate)
    }
}

final class DefaultGameRulesTests: XCTestCase {
    private let fieldSize = 1
    private let winCoordinates: [[Field.Coordinate]] = [[.init(x: 0, y: 0)]]

    func test_init() {
        let _ = makeSut()
    }

    func test_getWinner_returnsWinner() {
        assert(winner: nil) { _ in }
        assert(winner: .cross) {
            try! $0.put(.cross, at: .init(x: 0, y: 0))
        }

        assert(winner: .zero) {
            try! $0.put(.zero, at: .init(x: 0, y: 0))
        }
    }

    func test_winCoordinates() {
        XCTAssertEqual(DefaultGameRules.winCoordinates, [
            [
                Field.Coordinate(x: 0, y: 0),
                Field.Coordinate(x: 0, y: 1),
                Field.Coordinate(x: 0, y: 2),
            ],
            [
                Field.Coordinate(x: 1, y: 0),
                Field.Coordinate(x: 1, y: 1),
                Field.Coordinate(x: 1, y: 2),
            ],
            [
                Field.Coordinate(x: 2, y: 0),
                Field.Coordinate(x: 2, y: 1),
                Field.Coordinate(x: 2, y: 2),
            ],
            [
                Field.Coordinate(x: 0, y: 0),
                Field.Coordinate(x: 1, y: 0),
                Field.Coordinate(x: 2, y: 0),
            ],
            [
                Field.Coordinate(x: 0, y: 1),
                Field.Coordinate(x: 1, y: 1),
                Field.Coordinate(x: 2, y: 1),
            ],
            [
                Field.Coordinate(x: 0, y: 2),
                Field.Coordinate(x: 1, y: 2),
                Field.Coordinate(x: 2, y: 2),
            ],
            [
                Field.Coordinate(x: 0, y: 0),
                Field.Coordinate(x: 1, y: 1),
                Field.Coordinate(x: 2, y: 2),
            ],
            [
                Field.Coordinate(x: 2, y: 0),
                Field.Coordinate(x: 1, y: 1),
                Field.Coordinate(x: 0, y: 2),
            ],
        ])
    }

    // MARK: - Helpers

    private func makeSut(field: Field? = nil) -> DefaultGameRules {
        DefaultGameRules(
            field: field ?? makeField(),
            winCoordinates: winCoordinates)
    }

    private func makeField() -> Field {
        Field(size: fieldSize)!
    }
    private func assert(
        winner: Player?,
        file: StaticString = #file,
        line: UInt = #line,
        when: (Field) -> ())
    {
        let field = makeField()
        let sut = makeSut(field: field)

        when(field)

        XCTAssertEqual(sut.getWinner(), winner, file: file, line: line)
    }
}
