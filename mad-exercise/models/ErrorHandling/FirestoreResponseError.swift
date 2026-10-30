//
//  FirestoreResponseError.swift
//  mad-exercise
//

// The Firestore API returns errors in a different format than the login API
nonisolated struct FirestoreResponseError: Codable {
    let error: FirestoreErrorDetail
}

nonisolated struct FirestoreErrorDetail: Codable {
    let code: Int
    let message: String
    let status: String
}

/*

 {
   "error": {
     "code": 401,
     "message": "Request had invalid authentication credentials. ...",
     "status": "UNAUTHENTICATED",
     "details": [ ... ]
   }
 }

 {
   "error": {
     "code": 403,
     "message": "Missing or insufficient permissions.",
     "status": "PERMISSION_DENIED"
   }
 }

 */
