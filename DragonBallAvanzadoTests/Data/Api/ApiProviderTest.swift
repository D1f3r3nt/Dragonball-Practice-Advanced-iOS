//
//  ApiProviderTest.swift
//  DragonBallAvanzadoTests
//
//  Created by Marc Santisteban Ruiz on 26/10/23.
//

import XCTest
@testable import DragonBallAvanzado

final class ApiProviderTest: XCTestCase {
    
    private var sut: ApiProviderProtocol!

    override func setUp() {
        sut = MockApiService(secureDataProvider: SecureDataProvider())
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_given_api_provider_when_login_with_user_and_password_then_get_valid_token() throws {
        let handler: (Notification) -> Bool = { notification in
            let token = notification.userInfo?[NotificationCenter.tokenKey] as? String
            XCTAssertNotNil(token)
            XCTAssertNotEqual(token ?? "", "")

            return true
        }

        let expectation = self.expectation(
            forNotification: NotificationCenter.apiProviderNotification,
            object: nil,
            handler: handler
        )

        sut.login(for: "d.jardon@gmail.com", with: "120485")
        wait(for: [expectation], timeout: 10.0)
    }

    func test_given_api_provider_when_get_all_heroes_then_heroes_exists() throws {
        let expectation = self.expectation(description: "Fetch one hero data")

        self.sut.getHeroes(by: nil, token: "") { heroes in
            XCTAssertNotEqual(heroes.count, 0)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func test_given_api_provider_when_get_one_hero_then_hero_exists() throws {
        let expectation = self.expectation(description: "Fetch one hero data")
        
        let heroName = "Goku"
        self.sut.getHeroes(by: heroName, token: "") { heroes in
            XCTAssertEqual(heroes.count, 1)
            XCTAssertEqual(heroes.first?.name ?? "", heroName)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func test_given_api_provider_when_get_one_hero_then_hero_not_exists() throws {
        let expectation = self.expectation(description: "Fetch one hero data")

        let heroName = "Thanos"
        self.sut.getHeroes(by: heroName, token: "") { heroes in
            XCTAssertEqual(heroes.count, 0)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_given_api_provider_when_call_locations_then_get_locations() throws {
        let expectation = self.expectation(description: "Fetch one location data")

        self.sut.getLocations(by: nil, token: "") { locations in
            XCTAssertNotEqual(locations.count, 0)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

}
