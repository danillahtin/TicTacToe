//
//  XCTestCase+Helpers.swift
//  CoreTests
//
//  Created by Danil Lahtin on 04.07.2020.
//  Copyright © 2020 Danil Lahtin. All rights reserved.
//

import XCTest


extension XCTestCase {
    func assert(
        throws expectedError: Error,
        when action: () throws -> (),
        file: StaticString = #file,
        line: UInt = #line)
    {
        do {
            try action()

            XCTFail("Expected to throw \(expectedError), got no error instead", file: file, line: line)
        } catch {
            guard (error as NSError) != (expectedError as NSError) else {
                return
            }

            XCTFail("Expected \(expectedError), got \(error) instead", file: file, line: line)
        }
    }
}
