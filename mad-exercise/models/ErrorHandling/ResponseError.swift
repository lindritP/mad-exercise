//
//  ResponseError.swift
//  mad-exercise
//
//  Created by Lindrit Prekaj on 23.09.26.
//

nonisolated struct ResponseError:Codable {
    let error: ErrorDetail
}

struct ErrorDetail:Codable{
    let code: Int
    let message: String
    let errors: [ErrorItem]
}

struct ErrorItem:Codable{
    let message: String
    let domain: String
    let reason: String
}

/*
 
 {
   "error": {
     "code": 400,
     "message": "INVALID_LOGIN_CREDENTIALS",
     "errors": [
       {
         "message": "INVALID_LOGIN_CREDENTIALS",
         "domain": "global",
         "reason": "invalid"
       }
     ]
   }
 }
 
 */
