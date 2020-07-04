//
//  FieldTests.swift
//  CoreTests
//
//  Created by Danil Lahtin on 27.06.2020.
//  Copyright © 2020 Danil Lahtin. All rights reserved.
//

import XCTest
import Core

final class FieldTests: XCTestCase {
    private let fieldSize = 2

    func test_initWithSize_makesFieldWithSize() {
        typealias Field = Core.Field<Void>

        XCTAssertNotNil(Field(size: 3))
        XCTAssertNotNil(Field(size: 5))
        XCTAssertNotNil(Field(size: 6))
    }

    func test_initWithZeroOrNegativeSize_makesNil() {
        typealias Field = Core.Field<Void>

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
        let invalidCoordinate = Field<Void>.Error.invalidCoordinate
        let getValue = { _ = try field.value(at: self.makeCoordinate($0, $1)) }

        assert(throws: invalidCoordinate, when: { try getValue(-1, 0) })
        assert(throws: invalidCoordinate, when: { try getValue(0, -1) })
        assert(throws: invalidCoordinate, when: { try getValue(-1, -1) })
        assert(throws: invalidCoordinate, when: { try getValue(fieldSize, 0) })
        assert(throws: invalidCoordinate, when: { try getValue(0, fieldSize) })
        assert(throws: invalidCoordinate, when: { try getValue(fieldSize, fieldSize) })
    }

    func test_putCrossAtCoordinate_putsCross() {
        let field = makeSutBool()

        try! field.put(true, at: makeCoordinate(0, 0))
        XCTAssertEqual(try field.value(at: makeCoordinate(0, 0)), true)

        try! field.put(true, at: makeCoordinate(1, 0))
        XCTAssertEqual(try field.value(at: makeCoordinate(1, 0)), true)

        try! field.put(true, at: makeCoordinate(0, 1))
        XCTAssertEqual(try field.value(at: makeCoordinate(0, 1)), true)

        try! field.put(true, at: makeCoordinate(1, 1))
        XCTAssertEqual(try field.value(at: makeCoordinate(1, 1)), true)
    }

    func test_putZeroAtCoordinate_putsZero() {
        let field = makeSutBool()

        try! field.put(false, at: makeCoordinate(0, 0))
        XCTAssertEqual(try field.value(at: makeCoordinate(0, 0)), false)

        try! field.put(false, at: makeCoordinate(1, 0))
        XCTAssertEqual(try field.value(at: makeCoordinate(1, 0)), false)

        try! field.put(false, at: makeCoordinate(0, 1))
        XCTAssertEqual(try field.value(at: makeCoordinate(0, 1)), false)

        try! field.put(false, at: makeCoordinate(1, 1))
        XCTAssertEqual(try field.value(at: makeCoordinate(1, 1)), false)
    }

    func test_putValueOutsideField_throwsInvalidCoordinateError() {
        let field = makeSut()
        let invalidCoordinate = Field<Void>.Error.invalidCoordinate
        let put = { try field.put((), at: self.makeCoordinate($0, $1)) }

        assert(throws: invalidCoordinate, when: { try put(-1, 0) })
        assert(throws: invalidCoordinate, when: { try put(0, -1) })
        assert(throws: invalidCoordinate, when: { try put(-1, -1) })
        assert(throws: invalidCoordinate, when: { try put(fieldSize, 0) })
        assert(throws: invalidCoordinate, when: { try put(0, fieldSize) })
        assert(throws: invalidCoordinate, when: { try put(fieldSize, fieldSize) })
    }

    func test_putValueAtNonEmptyCoordinate_throwsCoordinateOccupiedError() {
        let field = makeSut()
        let coordinateOccupied = Field<Void>.Error.coordinateOccupied
        let value: Void = ()

        try! field.put(value, at: makeCoordinate(0, 0))
        assert(throws: coordinateOccupied, when: { try field.put(value, at: makeCoordinate(0, 0)) })

        try! field.put(value, at: makeCoordinate(1, 0))
        assert(throws: coordinateOccupied, when: { try field.put(value, at: makeCoordinate(1, 0)) })

        try! field.put(value, at: makeCoordinate(0, 1))
        assert(throws: coordinateOccupied, when: { try field.put(value, at: makeCoordinate(0, 1)) })

        try! field.put(value, at: makeCoordinate(1, 1))
        assert(throws: coordinateOccupied, when: { try field.put(value, at: makeCoordinate(1, 1)) })
    }

    func test_hasCoordinateAvailable() {
        let sut = makeSut()
        let value: Void = ()

        XCTAssertEqual(sut.hasCoordinateAvailable(), true)

        try! sut.put(value, at: makeCoordinate(0, 0))
        XCTAssertEqual(sut.hasCoordinateAvailable(), true)

        try! sut.put(value, at: makeCoordinate(0, 1))
        XCTAssertEqual(sut.hasCoordinateAvailable(), true)

        try! sut.put(value, at: makeCoordinate(1, 0))
        XCTAssertEqual(sut.hasCoordinateAvailable(), true)

        try! sut.put(value, at: makeCoordinate(1, 1))
        XCTAssertEqual(sut.hasCoordinateAvailable(), false)
    }

    // MARK: - Helpers

    private func makeSut() -> Field<Void> {
        return Field(size: fieldSize)!
    }

    private func makeSutBool() -> Field<Bool> {
        return Field(size: fieldSize)!
    }

    private func makeCoordinate<T>(_ x: Int, _ y: Int) -> Field<T>.Coordinate {
        Field<T>.Coordinate(x: x, y: y)
    }
}
