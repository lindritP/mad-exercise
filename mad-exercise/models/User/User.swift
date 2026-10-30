//
//  User.swift
//  mad-exercise
//
//  Created by Lindrit Prekaj on 23.09.26.
//

nonisolated struct User: Codable, Hashable{
    let kind: String
    let localId: String
    let email: String
    let displayName: String
    let idToken: String
    let registered: Bool
    let refreshToken: String
    let expiresIn: String
}
