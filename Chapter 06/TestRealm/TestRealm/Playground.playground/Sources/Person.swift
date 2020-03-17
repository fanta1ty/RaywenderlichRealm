import Foundation
import RealmSwift
import CoreLocation

////////////////////////////
//  Person Realm Object
////////////////////////////

public class Person: Object {
  // object properties
  // string
  @objc public dynamic var firstName = ""
  @objc public dynamic var lastName: String?

  // date
  @objc public dynamic var born = Date.distantPast
  @objc public dynamic var deceased: Date?

  // data
  @objc public dynamic var photo: Data?

  // primitive types
  // bool
  @objc public dynamic var isVIP = false
  public let hasConsentedPublication = RealmOptional<Bool>()

  // Int, Int8, Int16, Int32, Int64
  @objc public dynamic var id = 0 //defaults to Int
  @objc public dynamic var hairCount: Int64 = 0
  public let timesContacted = RealmOptional<Int>()

  // Float, Double
  @objc public dynamic var height: Float = 0.0
  @objc public dynamic var weigth: Double = 0.0

  // dynamic properties
  public var isDeceased: Bool {
    return deceased != nil
  }

  public var fullName: String {
    guard let last = lastName else {
      return firstName
    }
    return "\(firstName) \(last)"
  }

  // custom type CLLocation
  let lat = RealmOptional<Double>()
  let lng = RealmOptional<Double>()

  public var lastLocation: CLLocation? {
    get {
      guard let lat = lat.value, let lng = lng.value else {
        return nil
      }
      return CLLocation(latitude: lat, longitude: lng)
    }
    set {
      guard let location = newValue else {
        lat.value = nil
        lng.value = nil
        return
      }
      lat.value = location.coordinate.latitude
      lng.value = location.coordinate.longitude
    }
  }

  // lists
  public let aliases = List<String>()
  
  // ignored properties
  public let idPropertyName = "id"
  public var temporaryId = 0 // automatically ignored in Swift4, because no Objc?
  @objc public dynamic var temporaryUploadId = 0

  override public static func ignoredProperties() -> [String] {
    return ["temporaryUploadId"]
  }

  // required vs. optional properties, default values, and required to override
  public convenience init(firstName: String, born: Date, id: Int) {
    self.init()
    self.firstName = firstName
    self.born = born
    self.id = id
  }

  // primary key (primary vs. auto-increment)
  @objc public dynamic var key = UUID().uuidString
  public override static func primaryKey() -> String? {
    return "key"
  }
}
