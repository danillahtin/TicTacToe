//
//  FieldTests.swift
//  CoreTests
//
//  Created by Danil Lahtin on 27.06.2020.
//  Copyright © 2020 Danil Lahtin. All rights reserved.
//

import XCTest

final class Field {
    init(size: Int) {

    }
}

final class FieldTests: XCTestCase {
    func test_initWithSize_makesFieldWithSize() {
        _ = Field(size: 3)
        _ = Field(size: 5)
    }
}