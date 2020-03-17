import Foundation

public class Example {
  public static var beforeEach: (() -> ())? = nil

  public static func of(_ description: String, action: (() -> ())? = nil) {
    beforeEach?()
    printHeader(description)
    action?()
  }

  private static func printHeader(_ message: String) {
    print("\nℹ️ \(message):")
    let length = Float(message.count + 3) * 1.2
    print(String(repeating: "—", count: Int(length)))
  }
}
