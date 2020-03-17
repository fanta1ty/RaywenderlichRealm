//
//  ViewController.swift
//  TestRealm
//
//  Created by User on 3/13/20.
//  Copyright © 2020 ThinhNguyen. All rights reserved.
//  Email: thinhnguyen12389@gmail.com
//

import UIKit
import Foundation
import RealmSwift
import CoreLocation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Setup
        let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TemporaryRealm"))
        try! TestDataSet.create(in: realm)

        print("Ready to play!")
        Example.of("Getting All Objects") {
            let people = realm.objects(Person.self)
            let articles = realm.objects(Article.self)
            
            print("\(people.count) people and \(articles.count) articles")
        }
        
        Example.of("Getting an Object by Primary Key") {
            let person = realm.object(ofType: Person.self, forPrimaryKey: "test-key")
            
            if let person = person {
                print("Person with Primary Key 'test-key': \(person.firstName)")
            } else {
                print("Not found")
            }
        }
        
        Example.of("Accessing Results") {
            let people = realm.objects(Person.self)
            
            print("Realm contains \(people.count) people")
            print("First person is: \(people.first!.fullName)")
            print("Second person is: \(people[1].fullName)")
            print("Last person is: \(people.last!.fullName)")
            
            let firstNames = people.map { $0.firstName }.joined(separator: ", ")
            print("First names of all people are: \(firstNames)")
            
            let namesAndIds = people.enumerated().map { "\($0.offset): \($0.element.firstName)" }.joined(separator: ", ")
            print("People and indexes: \(namesAndIds)")
            
        }
        
        Example.of("Results Indexes") {
            let people = realm.objects(Person.self)
            let person = people[1]
            
            if let index1 = people.index(of: person) {
                print("\(person.fullName) is at index \(index1)")
            }
            
            if let index2 = people.index(where: { $0.firstName.starts(with: "J")}) {
                print("Name starts with J at index \(index2)")
            }
            
            if let index3 = people.index(matching: "hairCount < %d", 10000) {
                print("Person with less than 10,000 hairs at index \(index3)")
            }
        }
        
        Example.of("Filtering") {
            let people = realm.objects(Person.self)
            print("All people: \(people.count)")
            
            let living = realm.objects(Person.self).filter("deceased = nil")
            print("Living people: \(living.count)")
            
            let predicate = NSPredicate(format: "hairCount < %d AND deceased = nil", 1000)
            let balding = realm.objects(Person.self).filter(predicate)
            
            print("Likely balding living people: \(balding.count)")
            
            let baldingStatic = Person.allAliveLikelyBalding(in: realm)
            print("Likely balding people (via static method): \(baldingStatic.count)")
        }
        
        Example.of("More Predicates") {
            let janesAndFranks = realm.objects(Person.self).filter("firstName IN %@", ["Jane", "Frank"])
            print("There are \(janesAndFranks.count) people named Jane or Frank")
            
            let balding = realm.objects(Person.self).filter("hairCount BETWEEN {%d, %d}", 10, 10000)
            print("There are \(balding.count) people likely balding")
            
            let search = realm.objects(Person.self).filter("""
                                                            firstName BEGINSWITH %@ OR
                                                            (lastName CONTAINS %@ AND hairCount > %d)
                                                            """, "J", "er", 10000)
            print("There are \(search.count) people matching our search")
        }
        
        Example.of("Subqueries") {
            let articleAboutFrank = realm.objects(Article.self).filter("""
            title != nil AND
            people.@count > 0 AND
            SUBQUERY(people, $person, $person.firstName BEGINSWITH %@ AND $person.born > %@).@count > 0
            """, "Frank", Date.distantPast)
            
            print("There are \(articleAboutFrank.count) articles about frank")
        }
        
        Example.of("Sorting") {
            let sortedPeople = realm.objects(Person.self).filter("firstName BEGINSWITH %@", "J").sorted(byKeyPath: "firstName")
            let names = sortedPeople.map {
                $0.firstName
            }.joined(separator: ", ")
            
            print("Sorted people: \(names)")
            
            let sortedPeopleDesc = realm.objects(Person.self).filter("firstName BEGINSWITH %@", "J").sorted(byKeyPath: "firstName", ascending: false)
            
            let revNames = sortedPeopleDesc.map {
                $0.firstName
            }.joined(separator: ", ")
            
            print("Reverse-sorted people: \(revNames)")
            
            let sortedArticles = realm.objects(Article.self).sorted(byKeyPath: "author.firstName")
            
            print("Sorted articles by author: \n\(sortedArticles.map { "- \($0.author!.fullName): \($0.title!)" }.joined(separator: "\n"))")
            
            let sortedPeopleMultiple = realm.objects(Person.self)
            .sorted(by: [SortDescriptor(keyPath: "firstName", ascending: true),
                         SortDescriptor(keyPath: "born", ascending: false)])
            
            print(sortedPeopleMultiple.map { "\($0.firstName) @ \($0.born)" }.joined(separator: ", "))
        }
        
        Example.of("Live Results") {
            let people = realm.objects(Person.self).filter("key == 'key'")
            print("Found \(people.count) people for key \"key\"")
            
            let newPerson1 = Person()
            newPerson1.key = "key"
            
            try! realm.write({
                realm.add(newPerson1)
            })
            
            print("Found \(people.count) people for key \"key\"")
            
            let newPerson2 = Person()
            newPerson2.key = "key"
            newPerson2.firstName = "Sher"
            
            print("Found \(people.count) people for key \"key\"")
        }
        
        Example.of("Cascading Inserts") {
            let newAuthor = Person()
            newAuthor.firstName = "New"
            newAuthor.lastName = "Author"
            
            let newArticle = Article()
            newArticle.author = newAuthor
            
            try! realm.write({
                realm.add(newArticle)
            })
            
            let author = realm.objects(Person.self).filter("firstName = 'New'").first!
            print("Author \(author.fullName) persisted with article")
        }
        
        Example.of("Updating") {
            let person = realm.objects(Person.self).first!
            
            print("\(person.fullName) initially - isVIP: \(person.isVIP), allowedPublication: \(person.allowedPublicationOn != nil ? "yes" : "no")")
            
            try! realm.write({
                person.isVIP = true
                person.allowedPublicationOn = Date()
            })
            
            print("\(person.fullName) initially - isVIP: \(person.isVIP), allowedPublication: \(person.allowedPublicationOn != nil ? "yes" : "no")")
        }
        
        Example.of("Deleting") {
            let people = realm.objects(Person.self)
            print("There are \(people.count) people before deletion: \(people.map{ $0.firstName }.joined(separator: ", "))")
            
            try! realm.write({
                realm.delete(people[0])
                realm.delete([people[1], people[5]])
                realm.delete(realm.objects(Person.self).filter("firstName BEGINSWITH 'J'"))
            })
            
            print("There are \(people.count) people before deletion: \(people.map{ $0.firstName }.joined(separator: ", "))")
            print("Empty before deleteAll? \(realm.isEmpty)")
            
            try! realm.write({
                realm.deleteAll()
            })
            
            print("Empty before deleteAll? \(realm.isEmpty)")
        }
    }
}

