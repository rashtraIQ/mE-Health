//
//  mE_HealthUITestsLaunchTests.swift
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

final class mE_HealthUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
