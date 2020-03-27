import Foundation
import RealmSwift

@objcMembers public class Article: Object {
  public dynamic var id = UUID().uuidString
  public dynamic var title: String?
  public let people = List<Person>()
  public dynamic var author: Person?
  public dynamic var date: Date?

  public override static func primaryKey() -> String? {
    return "id"
  }
}
