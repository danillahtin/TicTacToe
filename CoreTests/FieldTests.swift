//
//  FieldTests.swift
//  CoreTests
//
//  Created by Danil Lahtin on 27.06.2020.
//  Copyright © 2020 Danil Lahtin. All rights reserved.
//

import XCTest

final class Field {
    enum Error: Swift.Error {
        case invalidCoordinate
    }

    struct Coordinate: Hashable {
        let x: Int
        let y: Int
    }

    enum Value {
        case empty
        case cross
        case zero
    }

    private let size: Int
    private var values: [Coordinate: Value] = [:]

    init?(size: Int) {
        guard size > 0 else {
            return nil
        }

        self.size = size
    }

    private func isValid(coordinate: Coordinate) -> Bool {
        let range = (0..<size)

        return range.contains(coordinate.x) && range.contains(coordinate.y)
    }

    func value(at coordinate: Coordinate) throws -> Value {
        guard isValid(coordinate: coordinate) else {
            throw Error.invalidCoordinate
        }

        return values[coordinate] ?? .empty
    }

    func put(_ value: Value, at coordinate: Coordinate) {
        values[coordinate] = value
    }
}

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

        XCTAssertEqual(try field.value(at: makeCoordinate(0, 0)), .empty)
        XCTAssertEqual(try field.value(at: makeCoordinate(0, 1)), .empty)
        XCTAssertEqual(try field.value(at: makeCoordinate(1, 0)), .empty)
        XCTAssertEqual(try field.value(at: makeCoordinate(1, 1)), .empty)
    }

    func test_getValueOutsideField_throwsInvalidCoordinateError() {
        let field = makeSut()

        assert(throws: .invalidCoordinate, when: { _ = try field.value(at: makeCoordinate(-1, 0)) })
        assert(throws: .invalidCoordinate, when: { _ = try field.value(at: makeCoordinate(0, -1)) })
        assert(throws: .invalidCoordinate, when: { _ = try field.value(at: makeCoordinate(-1, -1)) })
        assert(throws: .invalidCoordinate, when: { _ = try field.value(at: makeCoordinate(3, 0)) })
        assert(throws: .invalidCoordinate, when: { _ = try field.value(at: makeCoordinate(0, 3)) })
        assert(throws: .invalidCoordinate, when: { _ = try field.value(at: makeCoordinate(3, 3)) })
    }

    func test_putCrossAtCoordinate_putsCross() {
        let field = makeSut()

        field.put(.cross, at: makeCoordinate(0, 0))
        XCTAssertEqual(try field.value(at: makeCoordinate(0, 0)), .cross)

        field.put(.cross, at: makeCoordinate(1, 0))
        XCTAssertEqual(try field.value(at: makeCoordinate(1, 0)), .cross)

        field.put(.cross, at: makeCoordinate(0, 1))
        XCTAssertEqual(try field.value(at: makeCoordinate(0, 1)), .cross)

        field.put(.cross, at: makeCoordinate(1, 1))
        XCTAssertEqual(try field.value(at: makeCoordinate(1, 1)), .cross)
    }

    func test_putZeroAtCoordinate_putsZero() {
        let field = makeSut()

        field.put(.zero, at: makeCoordinate(0, 0))
        XCTAssertEqual(try field.value(at: makeCoordinate(0, 0)), .zero)

        field.put(.zero, at: makeCoordinate(1, 0))
        XCTAssertEqual(try field.value(at: makeCoordinate(1, 0)), .zero)

        field.put(.zero, at: makeCoordinate(0, 1))
        XCTAssertEqual(try field.value(at: makeCoordinate(0, 1)), .zero)

        field.put(.zero, at: makeCoordinate(1, 1))
        XCTAssertEqual(try field.value(at: makeCoordinate(1, 1)), .zero)
    }

    // MARK: - Helpers

    private func makeSut() -> Field {
        return Field(size: testFieldSize)!
    }

    private func makeCoordinate(_ x: Int, _ y: Int) -> Field.Coordinate {
        .init(x: x, y: y)
    }

    private func assert(
        throws expectedError: Field.Error,
        when action: () throws -> (),
        file: StaticString = #file,
        line: UInt = #line)
    {
        do {
            try action()

            XCTFail("Expected to throw \(expectedError), got no error instead", file: file, line: line)
        } catch {
            if let error = error as? Field.Error, error == expectedError {
                return
            }

            XCTFail("Expected \(expectedError), got \(error) instead", file: file, line: line)
        }
    }
}
