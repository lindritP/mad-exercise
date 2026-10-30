import SwiftUI

struct CountriesView : View {


    let user: User
    let networking: Networking

    var body: some View{
        Text("Hier kommen die Länder hin. 🇦🇱")
        .navigationTitle("Countries")

        .onAppear(perform: {
            networking.getCountries(idToken: user.idToken) { countries, error in
                if let error {
                    print(error.message)
                    return
                }
                print("Loaded \(countries?.count ?? 0) countries")
            }
        })
    }
}