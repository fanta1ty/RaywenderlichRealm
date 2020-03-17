import Foundation
import RealmSwift
import PlaygroundSupport

Example.of("Observing an Object")
PlaygroundPage.current.needsIndefiniteExecution = true

//: **Setup Realm**
let configuration = Realm.Configuration(inMemoryIdentifier: "TemporaryRealm")
let realm = try! Realm(configuration: configuration)

let article = Article()
article.id = "new-article"

try! realm.write({
    realm.add(article)
})

let token = article.observe { change in
    switch change {
    case .change(let properties):
        for property in properties {
            switch property.name {
            case "title":
                print("📝 Article title changed from \(property.oldValue ?? "nil") to \(property.newValue ?? "nil")")
                
            case "author":
                print("🌜Author changed to \(property.newValue ?? "nil")")
                
            default:
                break
            }
        }
        
        if properties.contains(where: { $0.name == "date" }) {
            print("date has changed to \(article.date)")
        }
        break
        
    case .error(let error):
        print("Error occurred: \(error)")
        
    case .deleted:
        print("Article was deleted")
    }
}

print("Subscription token: \(token)")

try! realm.write({
    article.title = "Work in progress"
})

DispatchQueue.global(qos: .background).async {
    let realm = try! Realm(configuration: configuration)
    
    if let article = realm.object(ofType: Article.self, forPrimaryKey: "new-article") {
        try! realm.write({
            article.title = "Actual title"
            article.author = Person()
        })
    }
}
