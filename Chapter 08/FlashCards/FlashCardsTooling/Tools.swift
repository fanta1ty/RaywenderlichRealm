/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import RealmSwift

private func wordsList() -> [(String, String)] {
  return [("Cuaderno", "Notebook\nElla tiene muchos cuadernos."),
          ("Casa", "House\nNuestra familia vive en una gran casa"),
          ("Aprender", "To learn\nMe gusta aprender"),
          ("Hacer", "To do\nEmpecé a hacer yoga"),
          ("Tren", "Train\nEl viaje en tren es muy rápido"),
          ("Playa", "Beach\n¡Vamos a la playa!"),
          ("Pelota", "Ball\nSu regalo de cumpleaños es una nueva pelota")]
}

struct Tools {

  private static func createBundledWordsRealm() {

  }

  private static func createBundledSetsRealm() {
    let conf = Realm.Configuration(fileURL: try! Path.inDocuments("tooling-bundledSets.realm"),
                                   objectTypes: [FlashCardSet.self, FlashCard.self])
    let newBundledSetsRealm = try! Realm(configuration: conf)

    let set1Cards = downloadableSets["Numbers"]!
                    .map { ($0[0], $0[1]) }
                    .map(FlashCard.init)

    let set1 = FlashCardSet("Numbers", cards: set1Cards)
    let set2 = FlashCardSet("Colors", cards: [])
    let set3 = FlashCardSet("Greetings", cards: [])

    try! newBundledSetsRealm.write {
      newBundledSetsRealm.deleteAll()
      newBundledSetsRealm.add([set1, set2, set3])
    }

    print("""
    *
    * Created: \(newBundledSetsRealm.configuration.fileURL!)
    *
    """)
  }
}

