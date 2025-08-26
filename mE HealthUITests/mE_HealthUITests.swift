//
//  mE_HealthUITests.swift
//  mE HealthUITests
//
//  # =============================================================================
# mEinstein - CONFIDENTIAL
#
# Copyright ©️ 2025 mEinstein Inc. All Rights Reserved.
#
# NOTICE: All information contained herein is and remains the property of
# mEinstein Inc. The intellectual and technical concepts contained herein are
# proprietary to mEinstein Inc. and may be covered by U.S. and foreign patents,
# patents in process, and are protected by trade secret or copyright law.
#
# Dissemination of this information, or reproduction of this material,
# is strictly forbidden unless prior written permission is obtained from
# mEinstein Inc.
#
# Author(s): Ishant 
# ============================================================================= on 6/05/25.
//

import XCTest

final class mE_HealthUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
