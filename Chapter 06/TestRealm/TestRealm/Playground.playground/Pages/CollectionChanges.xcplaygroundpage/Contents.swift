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
    
}
