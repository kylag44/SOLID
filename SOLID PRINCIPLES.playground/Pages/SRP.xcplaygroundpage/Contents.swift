//: [Previous](@previous)

import UIKit

//: [Next](@next)

/*:
 ## SINGLE RESPONSIBILITY PRINCIPLE (SRP)
 
 * It's the S in SOLID
 * "A class should have only one reason to change."
 * When a class takes on more than one responsibility those responsibilities may become entangled (calling each other)
 * A change to one of the responsibilities may break code unexpectedly since client code may be sending messages that only use part of the class (one of its responsibilities)
 * SRP makes code more modular, and hence easier to reuse
 * SRP makes code easier to test
 */


class Book1 {
    let title:String
    let author:String
    var currentPage: Int?

    init(title:String, author:String) {
        self.title = title
        self.author = author
    }
    
    func saveDataToPlist(data:[Book1]?) {
        if data == nil {
            self.saveDataToPlist([self])
        } else {
            print("saves to Plist")
        }
    }
}

/*: 
 * Let's say we have bunch of other classes that have a dependency on the Book class's saveDataToPlist() function. Like this viewController
 */

class MyVC: UIViewController {
    func fakeEvent() {
        let bk = Book1(title: "Mastery", author: "Robert Greene")
        bk.currentPage = 20
        bk.saveDataToPlist(nil)
    }
}

let myVC = MyVC()
myVC.fakeEvent()

/*:
 * Now let's imagine we decide to change our persistence to core data, or parse, or both
 * Now any code that calls into Book's save method passing in a Book will break and we will be required to open the client class and modify it
 * So, the save functionality is a responsibility in this class that's an axis of change
 * SRP dictates that we should move the save responsibility to a separate class
 */


// build an interface first
protocol Persistence {
    func save()
}

class CoreData:Persistence {
    func save() {
        print("core data saved")
    }
}

class ParseData:Persistence {
    func save() {
        print("parse saved")
    }
}

// Book2

class Book2 {
    private let title:String
    private let author:String
    private var currentPage: Int?
    private let dataManager:Persistence
    // Notice we're using Dependency Injection
    init(title:String, author:String, dataManager:Persistence) {
        self.title = title
        self.author = author
        self.dataManager = dataManager
    }
    func save() {
        self.dataManager.save()
    }
}

class MyVC2: UIViewController {
    func fakeEvent() {
        let dataManager:Persistence = CoreData()
        let bk = Book2(title: "Mastery", author: "Robert Greene", dataManager:dataManager)
        bk.currentPage = 20
        bk.save()
    }
}

/*:
 
 * Notice we moved what changes (the persistence layer) into its own class and encapsulated it, that is, wrapped it in an abstract structure so that we no longer have a concrete dependency
 * We also use polymorphism since all of the concrete persistence objects implement the same save function. 
 * This is also an example of the open-closed principle.
 * So, let's look at that next.
 */













