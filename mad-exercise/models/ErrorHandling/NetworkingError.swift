//
//  NetworkingError.swift
//  mad-exercise
//
//  Created by Lindrit Prekaj on 23.09.26.
//


enum NetworkingError: Error {
    case serializingError
    case nonEmailAddressError
    case wrongEmailAdressError
    case wrongCredentialsError
    case noNetworkError
    case unexpectedJSONError
    case nonSuccessfulResponseError
    case unknownError
}
