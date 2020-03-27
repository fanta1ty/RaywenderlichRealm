import Foundation
import RealmSwift
import PlaygroundSupport

Example.of("Collection Changes")
PlaygroundPage.current.needsIndefiniteExecution = true

//: **Setup Realm and preload some data**
let configuration = Realm.Configuration(inMemoryIdentifier: "TemporaryRealm")
let realm = try! Realm(configuration: configuration)

try! TestDataSet.create(in: realm)

let article = Article()
article.title = "New Article"

try! realm.write({
    realm.add(article)
})

let token = article.people.observe { changes in
    switch changes {
    case .initial(let people):
        print("Initial count: \(people.count)")
    
    case .update(let people, let deletions, let insertions, let modifications):
        print("Current count: \(people.count)")
        print("Inserted \(insertions), Modified: \(modifications), Deleted \(deletions)")
    
    case .error(let error):
        print("Error: \(error)")
    }
}

try! realm.write({
    article.people.append(Person())
    article.people.append(Person())
    article.people.append(Person())
})

try! realm.write({
    article.people[1].isVIP = true
})

try! realm.write({
    article.people.remove(at: 0)
    article.people[1].firstName = "Joel"
})

try! realm.write({
    article.people.removeAll()
})
