import Foundation
import RealmSwift
import PlaygroundSupport

Example.of("Observing a Collection")
PlaygroundPage.current.needsIndefiniteExecution = true

//: **Setup Realm and preload some data**
let configuration = Realm.Configuration(inMemoryIdentifier: "TemporaryRealm")
let realm = try! Realm(configuration: configuration)

try! TestDataSet.create(in: realm)

let people = realm.objects(Person.self).sorted(byKeyPath: "firstName")
let token = people.observe { changes in
    print("Current count: \(people.count)")
}

try! realm.write({
    realm.add(Person())
})

try! realm.write({
    realm.add(Person())
})

DispatchQueue.global(qos: .background).sync {
    let realm = try! Realm(configuration: configuration)
    try! realm.write({
        realm.add(Person())
    })
}

DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
    token.invalidate()
}

DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    try! realm.write({
        realm.add(Person())
    })
}
