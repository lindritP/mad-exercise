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
    
    
}










