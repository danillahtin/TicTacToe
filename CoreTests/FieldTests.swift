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

    func value(at coordinate: Coordinate) throws -> Value {
        if coordinate.x < 0 || coordinate.y < 0 || coordinate.x >= size || coordinate.y >= size {
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

        XCTAssertEqual(try field.value(at: Field.Coordinate(x: 0, y: 0)), .empty)
        XCTAssertEqual(try field.value(at: Field.Coordinate(x: 0, y: 1)), .empty)
        XCTAssertEqual(try field.value(at: Field.Coordinate(x: 1, y: 0)), .empty)
        XCTAssertEqual(try field.value(at: Field.Coordinate(x: 1, y: 1)), .empty)
    }

    func test_getValueOutsideField_throwsInvalidCoordinateError() {
        let field = makeSut()

        assertValue(from: field, at: .init(x: -1, y: 0), throws: .invalidCoordinate)
        assertValue(from: field, at: .init(x: 0, y: -1), throws: .invalidCoordinate)
        assertValue(from: field, at: .init(x: -1, y: -1), throws: .invalidCoordinate)
        assertValue(from: field, at: .init(x: 3, y: 0), throws: .invalidCoordinate)
        assertValue(from: field, at: .init(x: 0, y: 3), throws: .invalidCoordinate)
        assertValue(from: field, at: .init(x: 3, y: 3), throws: .invalidCoordinate)
    }

    func test_putCrossAtCoordinate_putsCross() {
        let field = makeSut()

        field.put(.cross, at: .init(x: 0, y: 0))
        XCTAssertEqual(try field.value(at: Field.Coordinate(x: 0, y: 0)), .cross)

        field.put(.cross, at: .init(x: 1, y: 0))
        XCTAssertEqual(try field.value(at: Field.Coordinate(x: 1, y: 0)), .cross)

        field.put(.cross, at: .init(x: 0, y: 1))
        XCTAssertEqual(try field.value(at: Field.Coordinate(x: 0, y: 1)), .cross)

        field.put(.cross, at: .init(x: 1, y: 1))
        XCTAssertEqual(try field.value(at: Field.Coordinate(x: 1, y: 1)), .cross)
    }

    func test_putZeroAtCoordinate_putsZero() {
        let field = makeSut()

        field.put(.zero, at: .init(x: 0, y: 0))
        XCTAssertEqual(try field.value(at: Field.Coordinate(x: 0, y: 0)), .zero)

        field.put(.zero, at: .init(x: 1, y: 0))
        XCTAssertEqual(try field.value(at: Field.Coordinate(x: 1, y: 0)), .zero)

        field.put(.zero, at: .init(x: 0, y: 1))
        XCTAssertEqual(try field.value(at: Field.Coordinate(x: 0, y: 1)), .zero)

        field.put(.zero, at: .init(x: 1, y: 1))
        XCTAssertEqual(try field.value(at: Field.Coordinate(x: 1, y: 1)), .zero)
    }

    // MARK: - Helpers

    func makeSut() -> Field {
        return Field(size: testFieldSize)!
    }

    func assertValue(
        from sut: Field,
        at coordinate: Field.Coordinate,
        throws expectedError: Field.Error,
        file: StaticString = #file,
        line: UInt = #line)
    {
        do {
            let value = try sut.value(at: coordinate)
            XCTFail("Expected to fail at \(coordinate), got \(value) instead", file: file, line: line)
        } catch {
            if let error = error as? Field.Error, error == expectedError {
                return
            }

            XCTFail("Expected \(expectedError), got \(error) instead", file: file, line: line)
        }
    }
}
