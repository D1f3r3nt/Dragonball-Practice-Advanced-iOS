//
//  SecureDataProviderTest.swift
//  DragonBallAvanzado
//
//  Created by Marc Santisteban Ruiz on 26/10/23.
//

import XCTest
@testable import DragonBallAvanzado

final class SecureDataProviderTest: XCTestCase {

    private var sut: SecureDataProvierProtocol!

    override func setUp() {
        sut = SecureDataProvider()
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_save_and_get_token() {
        let token = "fantasy_token"
        sut.save(token: token)
        let dataToken = sut.getToken()
        
        XCTAssertEqual(token, dataToken)
    }
    
    func test_clear_token() {
        let token = "fantasy_token"
        sut.save(token: token)
        let dataToken = sut.getToken()
        sut.clear()
        let clearToken = sut.getToken()
        
        XCTAssertEqual(token, dataToken)
        XCTAssertNil(clearToken)
    }

}
