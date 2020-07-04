//
//  Field.swift
//  Core
//
//  Created by Danil Lahtin on 27.06.2020.
//  Copyright © 2020 Danil Lahtin. All rights reserved.
//

public final class Field {
    public enum Error: Swift.Error {
        case invalidCoordinate
        case coordinateOccupied
    }

    public struct Coordinate: Hashable {
        public let x: Int
        public let y: Int

        public init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
    }

    private let size: Int
    private var values: [Coordinate: Player] = [:]

    public init?(size: Int) {
        guard size > 0 else {
            return nil
        }

        self.size = size
    }

    private func isValid(coordinate: Coordinate) -> Bool {
        let range = 0..<size

        return range.contains(coordinate.x) && range.contains(coordinate.y)
    }

    public func value(at coordinate: Coordinate) throws -> Player? {
        guard isValid(coordinate: coordinate) else {
            throw Error.invalidCoordinate
        }

        return values[coordinate]
    }

    public func put(_ player: Player, at coordinate: Coordinate) throws {
        guard try self.value(at: coordinate) == nil else {
            throw Error.coordinateOccupied
        }

        values[coordinate] = player
    }
}
