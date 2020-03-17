import Foundation
import RealmSwift

public class TestDataSet {
  public static func create(`in` realm: Realm) throws {

    let author1 = Person(firstName: "Klark", born: Date(timeIntervalSince1970: 0), id: 1)
    author1.hairCount = 1284639265
    author1.born = Date(timeIntervalSince1970: 0)
    author1.lastName = "Kent"

    let author2 = Person(firstName: "John", born: Date(timeIntervalSince1970: -30000), id: 2)
    author2.hairCount = 140
    author2.born = Date(timeIntervalSince1970: 1806750000)
    author2.lastName = "Smith"

    let person1 = Person(firstName: "Jane", born: Date(timeIntervalSince1970: +50000), id: 3)
    person1.hairCount = 1284639265
    person1.lastName = "Doe"
    person1.hasConsentedPublication.value = true
    person1.key = "test-key"

    let person2 = Person(firstName: "Boe", born: Date(timeIntervalSince1970: +50000), id: 4)
    person2.hairCount = 1284639265
    person2.lastName = "Carter"
    person2.deceased = Date(timeIntervalSince1970: 1806750000)
    person2.hasConsentedPublication.value = true

    let person3 = Person(firstName: "Frank", born: Date(timeIntervalSince1970: +30000), id: 5)
    person3.hairCount = 100000
    person3.lastName = "Power"
    person3.hasConsentedPublication.value = false
    person3.aliases.append("Franky The Cone")
    person3.aliases.append("Big Frank")

    let article1 = Article()
    article1.title = "Jane Doe launches a successfull new product"
    article1.author = author1
    article1.people.append(person1)

    let article2 = Article()
    article2.title = "Musem of Modern Art opens a Boe Carter retrospective curated by Jane Doe"
    article2.author = author2
    article2.people.append(person3)
    article2.people.append(person1)

    try! realm.write {
      realm.add(author1)
      realm.add(author2)
      realm.add(person1)
      realm.add(person2)
      realm.add(article1)
      realm.add(article2)
    }
  }
}
