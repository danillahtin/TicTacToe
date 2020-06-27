//
//  FieldTests.swift
//  CoreTests
//
//  Created by Danil Lahtin on 27.06.2020.
//  Copyright © 2020 Danil Lahtin. All rights reserved.
//

import XCTest

final class Field {
    init?(size: Int) {
        return nil
    }
}

final class FieldTests: XCTestCase {
    func test_initWithSize_makesFieldWithSize() {
        _ = Field(size: 3)
        _ = Field(size: 5)
    }

    func test_initWithZeroOrNegativeSize_makesNil() {
        XCTAssertNil(Field(size: 0))
        XCTAssertNil(Field(size: -1))
        XCTAssertNil(Field(size: -2))
        XCTAssertNil(Field(size: -3))
    }
}
