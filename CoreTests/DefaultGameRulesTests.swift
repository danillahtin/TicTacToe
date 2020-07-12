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
    let size = 3
    let field: Core.Field<Player>

    init(field: Core.Field<Player>) {
        self.field = field
    }

    func getWinner() -> Player? {
        var winCoordinates: [[Field.Coordinate]] = (0..<size).flatMap({ x in
            [
                (0..<size).map({ .init(x: x, y: $0) }),
                (0..<size).map({ .init(x: $0, y: x) }),
            ]
        })

        winCoordinates.append((0..<size).map({ .init(x: $0, y: $0) }))
        winCoordinates.append((0..<size).map({ .init(x: $0, y: size - $0 - 1) }))

        return winCoordinates.first(where: filledWithSamePlayer).flatMap({
            try! field.value(at: $0.first!)
        })
    }

    private func filledWithSamePlayer(coordinates: [Field.Coordinate]) -> Bool {
        let players: [Player] = coordinates.compactMap({ try! field.value(at: $0) })

        guard players.count == coordinates.count, !players.isEmpty else {
            return false
        }

        return players.reduce(true, { $0 && $1 == players.first })
    }
}

final class DefaultGameRulesTests: XCTestCase {
    func test_init() {
        let _ = makeSut()
    }

    func test_getWinner_returnsWinner() {
        assert(winner: nil) { _ in }

        assert(winner: .cross) {
            try! $0.put(.cross, at: .init(x: 0, y: 0))
            try! $0.put(.cross, at: .init(x: 0, y: 1))
            try! $0.put(.cross, at: .init(x: 0, y: 2))
        }

        assert(winner: .cross) {
            try! $0.put(.cross, at: .init(x: 1, y: 0))
            try! $0.put(.cross, at: .init(x: 1, y: 1))
            try! $0.put(.cross, at: .init(x: 1, y: 2))
        }

        assert(winner: .cross) {
            try! $0.put(.cross, at: .init(x: 2, y: 0))
            try! $0.put(.cross, at: .init(x: 2, y: 1))
            try! $0.put(.cross, at: .init(x: 2, y: 2))
        }

        assert(winner: .zero) {
            try! $0.put(.zero, at: .init(x: 0, y: 0))
            try! $0.put(.zero, at: .init(x: 0, y: 1))
            try! $0.put(.zero, at: .init(x: 0, y: 2))
        }

        assert(winner: .zero) {
            try! $0.put(.zero, at: .init(x: 1, y: 0))
            try! $0.put(.zero, at: .init(x: 1, y: 1))
            try! $0.put(.zero, at: .init(x: 1, y: 2))
        }

        assert(winner: .zero) {
            try! $0.put(.zero, at: .init(x: 2, y: 0))
            try! $0.put(.zero, at: .init(x: 2, y: 1))
            try! $0.put(.zero, at: .init(x: 2, y: 2))
        }

        // --

        assert(winner: .cross) {
            try! $0.put(.cross, at: .init(x: 0, y: 0))
            try! $0.put(.cross, at: .init(x: 1, y: 0))
            try! $0.put(.cross, at: .init(x: 2, y: 0))
        }

        assert(winner: .cross) {
            try! $0.put(.cross, at: .init(x: 0, y: 1))
            try! $0.put(.cross, at: .init(x: 1, y: 1))
            try! $0.put(.cross, at: .init(x: 2, y: 1))
        }

        assert(winner: .cross) {
            try! $0.put(.cross, at: .init(x: 0, y: 2))
            try! $0.put(.cross, at: .init(x: 1, y: 2))
            try! $0.put(.cross, at: .init(x: 2, y: 2))
        }

        assert(winner: .zero) {
            try! $0.put(.zero, at: .init(x: 0, y: 0))
            try! $0.put(.zero, at: .init(x: 1, y: 0))
            try! $0.put(.zero, at: .init(x: 2, y: 0))
        }

        assert(winner: .zero) {
            try! $0.put(.zero, at: .init(x: 0, y: 1))
            try! $0.put(.zero, at: .init(x: 1, y: 1))
            try! $0.put(.zero, at: .init(x: 2, y: 1))
        }

        assert(winner: .zero) {
            try! $0.put(.zero, at: .init(x: 0, y: 2))
            try! $0.put(.zero, at: .init(x: 1, y: 2))
            try! $0.put(.zero, at: .init(x: 2, y: 2))
        }

        // --

        assert(winner: .cross) {
            try! $0.put(.cross, at: .init(x: 0, y: 0))
            try! $0.put(.cross, at: .init(x: 1, y: 1))
            try! $0.put(.cross, at: .init(x: 2, y: 2))
        }

        assert(winner: .cross) {
            try! $0.put(.cross, at: .init(x: 0, y: 2))
            try! $0.put(.cross, at: .init(x: 1, y: 1))
            try! $0.put(.cross, at: .init(x: 2, y: 0))
        }

        assert(winner: .zero) {
            try! $0.put(.zero, at: .init(x: 0, y: 0))
            try! $0.put(.zero, at: .init(x: 1, y: 1))
            try! $0.put(.zero, at: .init(x: 2, y: 2))
        }

        assert(winner: .zero) {
            try! $0.put(.zero, at: .init(x: 0, y: 2))
            try! $0.put(.zero, at: .init(x: 1, y: 1))
            try! $0.put(.zero, at: .init(x: 2, y: 0))
        }

        // --
        assert(winner: nil) {
            try! $0.put(.zero, at: .init(x: 0, y: 1))
            try! $0.put(.zero, at: .init(x: 1, y: 1))
            try! $0.put(.zero, at: .init(x: 2, y: 0))
        }

        assert(winner: nil) {
            try! $0.put(.cross, at: .init(x: 0, y: 1))
            try! $0.put(.cross, at: .init(x: 1, y: 1))
        }

        assert(winner: nil) {
            try! $0.put(.cross, at: .init(x: 0, y: 1))
            try! $0.put(.zero, at: .init(x: 2, y: 1))
        }
    }

    // MARK: - Helpers

    private func makeSut(field: Field? = nil) -> DefaultGameRules {
        DefaultGameRules(field: field ?? makeField())
    }

    private func makeField() -> Field {
        Field(size: 3)!
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
