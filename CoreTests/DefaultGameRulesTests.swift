//
//  DefaultGameRulesTests.swift
//  CoreTests
//
//  Created by Danil Lahtin on 12.07.2020.
//  Copyright © 2020 Danil Lahtin. All rights reserved.
//

import XCTest

final class DefaultGameRules {
    
}

final class DefaultGameRulesTests: XCTestCase {
    func test_init() {
        let _ = makeSut()
    }

    // MARK: - Helpers

    private func makeSut() -> DefaultGameRules {
        DefaultGameRules()
    }
}
