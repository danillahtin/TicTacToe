//
//  FieldTests.swift
//  CoreTests
//
//  Created by Danil Lahtin on 27.06.2020.
//  Copyright © 2020 Danil Lahtin. All rights reserved.
//

import XCTest
import Core

typealias Field = Core.Field<Player>

final class FieldTests: XCTestCase {
    private let testFieldSize = 2

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
        let field = makeSut()

        XCTAssertNil(try field.value(at: makeCoordinate(0, 0)))
        XCTAssertNil(try field.value(at: makeCoordinate(0, 1)))
        XCTAssertNil(try field.value(at: makeCoordinate(1, 0)))
        XCTAssertNil(try field.value(at: makeCoordinate(1, 1)))
    }

    func test_getValueOutsideField_throwsInvalidCoordinateError() {
        let field = makeSut()
        let invalidCoordinate = Field.Error.invalidCoordinate
        let getValue = { _ = try field.value(at: self.makeCoordinate($0, $1)) }

        assert(throws: invalidCoordinate, when: { try getValue(-1, 0) })
        assert(throws: invalidCoordinate, when: { try getValue(-1, 0) })
        assert(throws: invalidCoordinate, when: { try getValue(0, -1) })
        assert(throws: invalidCoordinate, when: { try getValue(-1, -1) })
        assert(throws: invalidCoordinate, when: { try getValue(3, 0) })
        assert(throws: invalidCoordinate, when: { try getValue(0, 3) })
        assert(throws: invalidCoordinate, when: { try getValue(3, 3) })
    }

    func test_putCrossAtCoordinate_putsCross() {
        let field = makeSut()

        try! field.put(.cross, at: makeCoordinate(0, 0))
        XCTAssertEqual(try field.value(at: makeCoordinate(0, 0)), .cross)

        try! field.put(.cross, at: makeCoordinate(1, 0))
        XCTAssertEqual(try field.value(at: makeCoordinate(1, 0)), .cross)

        try! field.put(.cross, at: makeCoordinate(0, 1))
        XCTAssertEqual(try field.value(at: makeCoordinate(0, 1)), .cross)

        try! field.put(.cross, at: makeCoordinate(1, 1))
        XCTAssertEqual(try field.value(at: makeCoordinate(1, 1)), .cross)
    }

    func test_putValueOutsideField_throwsInvalidCoordinateError() {
        let field = makeSut()
        let invalidCoordinate = Field.Error.invalidCoordinate
        let put = { try field.put($0, at: self.makeCoordinate($1, $2)) }

        assert(throws: invalidCoordinate, when: { try put(.cross, -1, 0) })
        assert(throws: invalidCoordinate, when: { try put(.cross, 0, -1) })
        assert(throws: invalidCoordinate, when: { try put(.cross, -1, -1) })
        assert(throws: invalidCoordinate, when: { try put(.cross, 3, 0) })
        assert(throws: invalidCoordinate, when: { try put(.cross, 0, 3) })
        assert(throws: invalidCoordinate, when: { try put(.cross, 3, 3) })

        assert(throws: invalidCoordinate, when: { try put(.zero, -1, 0) })
        assert(throws: invalidCoordinate, when: { try put(.zero, 0, -1) })
        assert(throws: invalidCoordinate, when: { try put(.zero, -1, -1) })
        assert(throws: invalidCoordinate, when: { try put(.zero, 3, 0) })
        assert(throws: invalidCoordinate, when: { try put(.zero, 0, 3) })
        assert(throws: invalidCoordinate, when: { try put(.zero, 3, 3) })
    }

    func test_putZeroAtCoordinate_putsZero() {
        let field = makeSut()

        try! field.put(.zero, at: makeCoordinate(0, 0))
        XCTAssertEqual(try field.value(at: makeCoordinate(0, 0)), .zero)

        try! field.put(.zero, at: makeCoordinate(1, 0))
        XCTAssertEqual(try field.value(at: makeCoordinate(1, 0)), .zero)

        try! field.put(.zero, at: makeCoordinate(0, 1))
        XCTAssertEqual(try field.value(at: makeCoordinate(0, 1)), .zero)

        try! field.put(.zero, at: makeCoordinate(1, 1))
        XCTAssertEqual(try field.value(at: makeCoordinate(1, 1)), .zero)
    }

    func test_putValueAtNonEmptyCoordinate_throwsCoordinateOccupiedError() {
        let field = makeSut()
        let coordinateOccupied = Field.Error.coordinateOccupied

        try! field.put(.zero, at: makeCoordinate(0, 0))
        assert(throws: coordinateOccupied, when: { try field.put(.zero, at: makeCoordinate(0, 0)) })

        try! field.put(.cross, at: makeCoordinate(1, 0))
        assert(throws: coordinateOccupied, when: { try field.put(.zero, at: makeCoordinate(1, 0)) })

        try! field.put(.zero, at: makeCoordinate(0, 1))
        assert(throws: coordinateOccupied, when: { try field.put(.cross, at: makeCoordinate(0, 1)) })

        try! field.put(.cross, at: makeCoordinate(1, 1))
        assert(throws: coordinateOccupied, when: { try field.put(.cross, at: makeCoordinate(1, 1)) })
    }

    // MARK: - Helpers

    private func makeSut() -> Field {
        return Field(size: testFieldSize)!
    }

    private func makeCoordinate(_ x: Int, _ y: Int) -> Field.Coordinate {
        Field.Coordinate(x: x, y: y)
    }
}
