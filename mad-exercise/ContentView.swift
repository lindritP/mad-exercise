//
//  ContentView.swift
//  mad-exercise
//
//  Created by Lindrit Prekaj on 22.09.26.
//




import SwiftUI

struct ContentView: View {
    
    private var hardCodedEmail = "test@test.at"
    private var hardoCodedPassword = "1234"
    
    @State private var emailAddress: String = ""
    @State private var password: String = ""
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
    
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
               
            
                // This code executes after 2 seconds// Check here if the login was successful}
                if emailAddress == hardCodedEmail && password == hardoCodedPassword {
                    alertMessage = "Successfull Login"
                    showAlert = true
                }else{
                    alertMessage = "Wrong Credentials"
                    showAlert = true
                }
                
                isLoggedIn = false
                    
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
