//
//  ValidationLoginTest.swift
//  DragonBallAvanzadoTests
//
//  Created by Marc Santisteban Ruiz on 26/10/23.
//

import XCTest
@testable import DragonBallAvanzado

final class ValidationLoginTest: XCTestCase {
    private var sut: LoginViewModel!

    override  func setUp() {
        let secureData = SecureDataProvider()
        sut = LoginViewModel(apiProvider: ApiProvider(),
                             secureData: secureData)
    }

    func test_given_valid_email_when_is_valid_then_true() throws {
        let validEmail = "d.jardon@gmail.com"
        let isEmailValid = sut.isValid(email: validEmail)

        XCTAssertTrue(isEmailValid)
    }

    func test_given_valid_email_when_not_valid_then_false() throws {
        let invalidEmail = "d.jardongmail.com"
        let isEmailValid = sut.isValid(email: invalidEmail)

        XCTAssertFalse(isEmailValid)
    }
    
    func test_given_valid_password_when_is_valid_then_true() throws {
        let validEmail = "d.jar"
        let isEmailValid = sut.isValid(password: validEmail)

        XCTAssertTrue(isEmailValid)
    }

    func test_given_valid_password_when_is_valid_then_false() throws {
        let invalidEmail = "asd"
        let isEmailValid = sut.isValid(password: invalidEmail)

        XCTAssertFalse(isEmailValid)
    }

}
