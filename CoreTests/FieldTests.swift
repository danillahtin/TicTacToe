//
//  FieldTests.swift
//  CoreTests
//
//  Created by Danil Lahtin on 27.06.2020.
//  Copyright © 2020 Danil Lahtin. All rights reserved.
//

import XCTest

final class Field {
    struct Coordinate: Hashable {
        let x: Int
        let y: Int
    }

    enum Value {
        case empty
        case cross
        case zero
    }

    private var values: [Coordinate: Value] = [:]

    init?(size: Int) {
        guard size > 0 else {
            return nil
        }
    }

    func value(at coordinate: Coordinate) -> Value {
        return values[coordinate] ?? .empty
    }

    func put(_ value: Value, at coordinate: Coordinate) {
        values[coordinate] = value
    }
}

final class FieldTests: XCTestCase {
    func test_initWithSize_makesFieldWithSize() {
        XCTAssertNotNil(Field(size: 3))
        XCTAssertNotNil(Field(size: 5))
        XCTAssertNotNil(Field(size: 6))
    }

    func test_initWithZeroOrNegativeSize_makesNil() {
        XCTAssertNil(Field(size: 0))
        XCTAssertNil(Field(size: -1))
        XCTAssertNil(Field(size: -2))
        XCTAssertNil(Field(size: -3))
    }

    func test_initialStateIsEmpty() {
        let field = Field(size: 2)!

        XCTAssertEqual(field.value(at: Field.Coordinate(x: 0, y: 0)), .empty)
        XCTAssertEqual(field.value(at: Field.Coordinate(x: 0, y: 1)), .empty)
        XCTAssertEqual(field.value(at: Field.Coordinate(x: 1, y: 0)), .empty)
        XCTAssertEqual(field.value(at: Field.Coordinate(x: 1, y: 1)), .empty)
    }

    func test_putCrossAtCoordinate_putsCross() {
        let field = Field(size: 2)!

        field.put(.cross, at: .init(x: 0, y: 0))
        XCTAssertEqual(field.value(at: Field.Coordinate(x: 0, y: 0)), .cross)

        field.put(.cross, at: .init(x: 1, y: 0))
        XCTAssertEqual(field.value(at: Field.Coordinate(x: 1, y: 0)), .cross)

        field.put(.cross, at: .init(x: 0, y: 1))
        XCTAssertEqual(field.value(at: Field.Coordinate(x: 0, y: 1)), .cross)

        field.put(.cross, at: .init(x: 1, y: 1))
        XCTAssertEqual(field.value(at: Field.Coordinate(x: 1, y: 1)), .cross)
    }

    func test_putZeroAtCoordinate_putsZero() {
        let field = Field(size: 2)!

        field.put(.zero, at: .init(x: 0, y: 0))
        XCTAssertEqual(field.value(at: Field.Coordinate(x: 0, y: 0)), .zero)

        field.put(.zero, at: .init(x: 1, y: 0))
        XCTAssertEqual(field.value(at: Field.Coordinate(x: 1, y: 0)), .zero)

        field.put(.zero, at: .init(x: 0, y: 1))
        XCTAssertEqual(field.value(at: Field.Coordinate(x: 0, y: 1)), .zero)

        field.put(.zero, at: .init(x: 1, y: 1))
        XCTAssertEqual(field.value(at: Field.Coordinate(x: 1, y: 1)), .zero)
    }
}
