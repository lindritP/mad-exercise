import SwiftUI

struct CountriesView : View {


    let user: User
    let networking: Networking

    @State private var countries: [Country]?
    @State private var errorMessage: String?

    private func loadCountries() {
        errorMessage = nil

        networking.getCountries(idToken: user.idToken) { countries, error in
            if let error {
                errorMessage = error.message
                return
            }
            self.countries = countries
        }
    }

    var body: some View{
        Group {
            if let countries {
                List(countries) { country in
                    NavigationLink {
                        CountryDetailView(country: country)
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(country.name)
                                    .font(.headline)
                                Text(country.native)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(country.capital)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            } else if let errorMessage {
                ContentUnavailableView {
                    Label("Länder konnten nicht geladen werden", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(errorMessage)
                } actions: {
                    Button("Erneut versuchen") {
                        loadCountries()
                    }
                }
            } else {
                ProgressView("Länder werden geladen…")
            }
        }
        .navigationTitle("Countries")

        // Only load once, so coming back from a detail view doesn't download everything again
        .onAppear(perform: {
            if countries == nil {
                loadCountries()
            }
        })
    }
}
