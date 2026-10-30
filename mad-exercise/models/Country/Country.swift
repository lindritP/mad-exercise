import Foundation

nonisolated struct Country: Decodable, Identifiable, Hashable {
    var ID: String
    var name: String
    var currency: String
    var capital: String
    var native: String
    var continent: String
    var phone: String
    var createTime: Date
    var updateTime: Date
    var languages: [String]

    var id: String { self.ID }

    private enum RootCodingKeys: String, CodingKey {
        case ID = "name"
        case createTime
        case updateTime
        case fields
    }

    private enum NestedCodingKeys: String, CodingKey {
        case name
        case currency
        case capital
        case native
        case continent
        case phone
        case languages
    }

    private enum StringValueCodingKeys: String, CodingKey {
        case stringValue
    }

    private enum ArrayValueCodingKeys: String, CodingKey {
        case arrayValue
    }

    private enum ArrayValueNestedCodingKeys: String, CodingKey {
        case values
    }

    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)
        self.ID = (try rootContainer.decode(String.self, forKey: .ID) as NSString).lastPathComponent
        createTime = try rootContainer.decode(Date.self, forKey: .createTime)
        updateTime = try rootContainer.decode(Date.self, forKey: .updateTime)

        let fieldsContainer = try rootContainer.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .fields)

        // Every field is wrapped like { "name": { "stringValue": "Austria" } }
        func decodeStringValue(forKey key: NestedCodingKeys) throws -> String {
            let stringValueContainer = try fieldsContainer.nestedContainer(keyedBy: StringValueCodingKeys.self, forKey: key)
            return try stringValueContainer.decode(String.self, forKey: .stringValue)
        }

        name = try decodeStringValue(forKey: .name)
        currency = try decodeStringValue(forKey: .currency)
        capital = try decodeStringValue(forKey: .capital)
        native = try decodeStringValue(forKey: .native)
        continent = try decodeStringValue(forKey: .continent)
        phone = try decodeStringValue(forKey: .phone)

        // { "languages": { "arrayValue": { "values": [ { "stringValue": "de" }, ... ] } } }
        let languagesContainer = try fieldsContainer.nestedContainer(keyedBy: ArrayValueCodingKeys.self, forKey: .languages)
        let arrayValueContainer = try languagesContainer.nestedContainer(keyedBy: ArrayValueNestedCodingKeys.self, forKey: .arrayValue)

        languages = []
        // Firestore omits "values" entirely when the array is empty
        if arrayValueContainer.contains(.values) {
            var valuesContainer = try arrayValueContainer.nestedUnkeyedContainer(forKey: .values)
            while !valuesContainer.isAtEnd {
                let stringValueContainer = try valuesContainer.nestedContainer(keyedBy: StringValueCodingKeys.self)
                languages.append(try stringValueContainer.decode(String.self, forKey: .stringValue))
            }
        }
    }
}
