//
//  ContentView.swift
//  mad-exercise
//
//  Created by Lindrit Prekaj on 22.09.26.
//




import SwiftUI

struct ContentView: View {
    
    
    @State private var emailAddress: String = "mad-fe@mad.at"
    @State private var password: String = "madmad"
    @State private var showAlert = false
    @State private var alertMessage =  ""
    @State private var isLoggedIn = false
    
    
    private func attemptLogin(){
        
        guard !emailAddress.isEmpty else {
            alertMessage = "Email Field is Empty"
            showAlert = true
            return
        }
        
        guard !password.isEmpty else {
            alertMessage = "Password Field is Empty"
            showAlert = true
            return
        }
        
            isLoggedIn = true
    
        Networking().login(email: emailAddress, password: password) {
            user, error in
            isLoggedIn = false
            
            if let error = error {
                switch error {
                    case .serializingError:
                        alertMessage = "Die Eingabe konnte nicht verarbeitet werden."
                    case .nonEmailAddressError:
                        alertMessage = "Das ist keine gültige E-Mail-Adresse."
                    case .wrongEmailAdressError:
                        alertMessage = "Diese E-Mail-Adresse existiert nicht."
                    case .wrongCredentialsError:
                        alertMessage = "E-Mail oder Passwort ist falsch."
                    case .noNetworkError:
                        alertMessage = "Keine Internetverbindung."
                    case .unexpectedJSONError:
                        alertMessage = "Die Antwort des Servers war unerwartet."
                    case .nonSuccessfulResponseError:
                        alertMessage = "Der Server hat einen Fehler gemeldet."
                    case .unknownError:
                        alertMessage = "Ein unbekannter Fehler ist aufgetreten."
                }
                showAlert = true
                return
            }
            if user != nil {
                alertMessage = "Login erfolgreich!"
                showAlert = true
            }
        }

    }
    
    @FocusState private var focusedField: Field?
    var body: some View {

        // Crucial problem: in landscape mode the screen height is small, and the
        // software keyboard can cover the TextFields (especially the password field)
        // since this VStack doesn't scroll to keep the focused field visible.
        VStack (alignment: .leading) {
            
            Text("Email")
                .font(
                .title2
                .bold()
                )
            
            TextField(
                "yourusername@example.com",
                text: $emailAddress
            )
            .textFieldStyle(.roundedBorder)
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            .focused($focusedField, equals: .email)
            .onSubmit {
                focusedField = .password
            }
            .submitLabel(.next)
            .disabled(isLoggedIn)
            
            
            Text("Password")
                .font(
                .title2
                .bold()
                )
            
            SecureField(
                "Your password",
                text: $password
            )
            .textFieldStyle(.roundedBorder)
            .textContentType(.password)
            .keyboardType(.default)
            .focused($focusedField, equals: .password)
            .onSubmit {
                attemptLogin()
            }
            .submitLabel(.done)
            .disabled(isLoggedIn)
            
            
            Button("Login") {
                attemptLogin()
                                    
                
             
            }
            .frame(maxWidth: .infinity)
            .font(.title .bold())
            .disabled(isLoggedIn)
            
            if isLoggedIn {
                ProgressView()
                    .frame(maxWidth: .infinity)
            }
            
            Spacer()
        }
        .padding(30)
        .alert(alertMessage, isPresented: $showAlert){
            Button("OK") {}
        }

        }
        
    }

#Preview {
    ContentView()
}
