//
//  apiHandler.swift
//  mad-exercise
//
//  Created by Lindrit Prekaj on 22.09.26.
//

import Foundation

class Networking {
    
    let urlSesion = URLSession(configuration: .default)
    
    
    func login(email: String, password: String, completionHandler: @escaping (User?, NetworkingError?)->Void){
        
        
        let url = URL(string:  "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDeLs8S6Hpy642JUPC3Pft-xVx8Ocs-uXY")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String : Any] = ["email": email, "password": password, "returnSecureToken": true]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options:[])
        else{
            //Handle Error
            completionHandler(nil, .serializingError)
            return
        }
        
        request.httpBody = jsonData
        
        let task = urlSesion.dataTask(with: request) {
            data, response, error in
            
            if let error = error {
                let nsError = error as NSError
                DispatchQueue.main.async {
                    if nsError.code == NSURLErrorNotConnectedToInternet {
                        completionHandler(nil, .noNetworkError)
                    } else {
                        completionHandler(nil, .unknownError)
                    }
                }
                return
            }
            
            guard let data = data else{
                DispatchQueue.main.async {
                completionHandler(nil, .unexpectedJSONError)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            if let user = try? decoder.decode(User.self, from: data) {
                DispatchQueue.main.async {
                    completionHandler(user, nil)
                }
                return
            }
            
            if let responseError = try? decoder.decode(ResponseError.self, from: data){
                switch responseError.error.message{
                case "INVALID_EMAIL":
                    DispatchQueue.main.async {
                    completionHandler(nil, .nonEmailAddressError)
                    }
                case "EMAIL_NOT_FOUND":
                        DispatchQueue.main.async {
                    completionHandler(nil, .wrongEmailAdressError)
                        }
                case "INVALID_PASSWORD", "INVALID_LOGIN_CREDENTIALS":
                            DispatchQueue.main.async {
                    completionHandler(nil, .wrongCredentialsError)
                            }
                default:
                                DispatchQueue.main.async {
                    completionHandler(nil, .nonSuccessfulResponseError)
                                }
                }
                
                return
                
                
            }
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

            DispatchQueue.main.async {
                if (200..<300).contains(statusCode) {
                    completionHandler(nil, .unexpectedJSONError)
                } else {
                    completionHandler(nil, .nonSuccessfulResponseError)
                }
            }

        }
        task.resume()
        
    }
    
    func getCountries(idToken: String, completionHandler: @escaping ([Country]?, NetworkingError?)->Void){

        let url = URL(string:  "https://firestore.googleapis.com/v1/projects/mad-fe/databases/(default)/documents/countries?pageSize=1000&orderBy=name")!

        var request = URLRequest(url: url)

        request.httpMethod = "GET"

        request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")

        let task = urlSesion.dataTask(with: request) {
            data, response, error in

            if let error = error {
                let nsError = error as NSError
                DispatchQueue.main.async {
                    if nsError.code == NSURLErrorNotConnectedToInternet {
                        completionHandler(nil, .noNetworkError)
                    } else {
                        completionHandler(nil, .unknownError)
                    }
                }
                return
            }

            guard let data = data else{
                DispatchQueue.main.async {
                    completionHandler(nil, .unexpectedJSONError)
                }
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(.iso8601Full)

            if let documentsContainer = try? decoder.decode(DocumentsContainer.self, from: data) {
                DispatchQueue.main.async {
                    completionHandler(documentsContainer.documents, nil)
                }
                return
            }

            if let responseError = try? decoder.decode(FirestoreResponseError.self, from: data){
                DispatchQueue.main.async {
                    switch responseError.error.status{
                    case "UNAUTHENTICATED", "PERMISSION_DENIED":
                        completionHandler(nil, .unauthorizedError)
                    default:
                        completionHandler(nil, .nonSuccessfulResponseError)
                    }
                }
                return
            }

            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

            DispatchQueue.main.async {
                if (200..<300).contains(statusCode) {
                    completionHandler(nil, .unexpectedJSONError)
                } else {
                    completionHandler(nil, .nonSuccessfulResponseError)
                }
            }

        }
        task.resume()

    }

}










