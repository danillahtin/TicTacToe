//
//  DefaultGameRules.swift
//  Core
//
//  Created by Danil Lahtin on 12.07.2020.
//  Copyright © 2020 Danil Lahtin. All rights reserved.
//

public final class DefaultGameRules {
    public typealias Field = Core.Field<Player>

    private let field: Field
    private let winCoordinates: [[Field.Coordinate]]

    public init(field: Field, winCoordinates: [[Field.Coordinate]]) {
        self.field = field
        self.winCoordinates = winCoordinates
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

extension DefaultGameRules: GameRules {
    public func getWinner() -> Player? {
        winCoordinates.lazy.compactMap(winner).first
    }
}

extension DefaultGameRules {
    public static var winCoordinates: [[Field.Coordinate]] {
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
}
