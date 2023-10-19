//
//  SecureDataProvider.swift
//  DragonBallAvanzado
//
//  Created by Marc Santisteban Ruiz on 11/10/23.
//

import Foundation
import KeychainSwift

protocol SecureDataProvierProtocol {
    func save(token: String)
    func getToken() -> String?
}

class SecureDataProvider: SecureDataProvierProtocol {
    private let keychain = KeychainSwift()
    
    private enum Key {
        static let token = "TOKEN_KEYCHAIN"
    }

    func save(token: String) {
        keychain.set(token, forKey: Key.token)
    }
    
    func getToken() -> String? {
        keychain.get(Key.token)
    }
    
}
