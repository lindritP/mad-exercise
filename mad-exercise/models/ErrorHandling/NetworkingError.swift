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
    case unauthorizedError
    case noNetworkError
    case unexpectedJSONError
    case nonSuccessfulResponseError
    case unknownError

    var message: String {
        switch self {
            case .serializingError:
                return "Die Eingabe konnte nicht verarbeitet werden."
            case .nonEmailAddressError:
                return "Das ist keine gültige E-Mail-Adresse."
            case .wrongEmailAdressError:
                return "Diese E-Mail-Adresse existiert nicht."
            case .wrongCredentialsError:
                return "E-Mail oder Passwort ist falsch."
            case .unauthorizedError:
                return "Deine Sitzung ist ungültig oder abgelaufen. Bitte melde dich erneut an."
            case .noNetworkError:
                return "Keine Internetverbindung."
            case .unexpectedJSONError:
                return "Die Antwort des Servers war unerwartet."
            case .nonSuccessfulResponseError:
                return "Der Server hat einen Fehler gemeldet."
            case .unknownError:
                return "Ein unbekannter Fehler ist aufgetreten."
        }
    }
}
