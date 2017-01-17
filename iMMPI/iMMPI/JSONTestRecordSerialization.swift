import Foundation

// TODO: drop @objc requirements when possible
final class JSONTestRecordSerialization: NSObject {
    let version = "1.0"

    let person: JSONPersonSerialization
    let answers: JSONAnswersSerialization
    let dateFormatter: DateFormatter

    init(person: JSONPersonSerialization = JSONPersonSerialization(),
         answers: JSONAnswersSerialization = JSONAnswersSerialization(),
         dateFormatter: DateFormatter = .serialization) {
        self.person = person
        self.answers = answers
        self.dateFormatter = dateFormatter
    }
}


extension JSONTestRecordSerialization {
    func encode(_ record: TestRecordProtocol) -> Data? {
        var json = person.encode(record.person)

        json[Key.version] = version
        json[Key.answers] = answers.encode(record.testAnswers)
        json[Key.date] = dateFormatter.string(from: record.date)

        return try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
    }


    func decode(_ data: Data?) -> TestRecord? {
        guard let data = data,
            let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String:Any],
            let version = json[Key.version] as? String, version == self.version else {
                return nil
        }

        guard let person = self.person.decode(json) else {
            return nil
        }

        guard let answers = self.answers.decode(json[Key.answers]) else {
            return nil
        }

        guard let date = dateFormatter.date(from: json[Key.date] as? String ?? "") else {
            return nil
        }

        return TestRecord(person: person, testAnswers: answers, date: date)
    }
}


extension JSONTestRecordSerialization {
    enum Key {
        static let answers = "answers"
        static let version = "version"
        static let date = "date"
    }
}
