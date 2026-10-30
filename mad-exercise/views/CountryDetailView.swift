import SwiftUI

struct CountryDetailView : View {

    let country: Country

    private func languageName(for code: String) -> String {
        Locale.current.localizedString(forLanguageCode: code) ?? code
    }

    private var currencyText: String {
        guard let currencyName = Locale.current.localizedString(forCurrencyCode: country.currency) else {
            return country.currency
        }
        return "\(currencyName) (\(country.currency))"
    }

    var body: some View{
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                Text(country.native)
                    .font(.title2)
                    .foregroundStyle(.secondary)

                GroupBox("Details") {
                    VStack(spacing: 12) {
                        LabeledContent("Capital", value: country.capital)
                        LabeledContent("Currency", value: currencyText)
                        LabeledContent("Continent", value: country.continent)
                        LabeledContent("Phone", value: "+\(country.phone)")
                    }
                    .frame(maxWidth: .infinity)
                }

                // Some countries have a lot of languages, so one Text is created per language
                // and the ScrollView keeps all of them reachable in every orientation
                GroupBox("Languages (\(country.languages.count))") {
                    VStack(spacing: 12) {
                        if country.languages.isEmpty {
                            Text("Keine Sprachen hinterlegt")
                                .foregroundStyle(.secondary)
                        }
                        ForEach(country.languages, id: \.self) { language in
                            LabeledContent(languageName(for: language), value: language)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }

                GroupBox("Metadata") {
                    VStack(spacing: 12) {
                        LabeledContent("ID", value: country.ID)
                        LabeledContent("Created", value: country.createTime.formatted(date: .abbreviated, time: .standard))
                        LabeledContent("Updated", value: country.updateTime.formatted(date: .abbreviated, time: .standard))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
        }
        .navigationTitle(country.name)
    }
}
