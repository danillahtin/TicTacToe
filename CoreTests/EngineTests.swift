//
//  EngineTests.swift
//  CoreTests
//
//  Created by Danil Lahtin on 04.07.2020.
//  Copyright © 2020 Danil Lahtin. All rights reserved.
//

import XCTest

final class Engine {
    
}

final class EngineTests: XCTestCase {
    func test_init() {
        let _ = makeSut()
    }

    // MARK: - Helpers

    private func makeSut() -> Engine {
        let sut = Engine()

        return sut
    }
}
