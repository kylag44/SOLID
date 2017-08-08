//: [Previous](@previous)

import Foundation

//: [Next](@next)


/*:
 ## Liskov Substitution Principle
 * "Subtypes must be substitutable for their base types."
 */

// Here's the general idea: I have a function that takes a parameter and I pass it an upcast instance. But this causes some unexpected behaviour

class BaseClass { }
class DerivedClass: BaseClass {}
func f(p:BaseClass) { }
f(p: DerivedClass()) // this misbehaves

// Square / Rectangle Classic Example

class Rectangle {
    // stored
    fileprivate var w:Int
    fileprivate var h:Int
    
    // computed
    var width: Int {
        get {
            return self.w
        }
        set {
            self.w = width
        }
    }
    
    var height: Int {
        get {
            return self.h
        }
        set {
            self.h = height
        }
    }
    
    init(w:Int, h:Int){
        self.w = w
        self.h = h
    }

    func area()->Int {
        return self.w * self.h
    }
}

class Square: Rectangle {
    override var width: Int {
        set {
            self.w = width
            self.h = width
        }
        get {
            return self.w
        }
    }
    override var height: Int {
        set {
            self.h = height
            self.w = height
        }
        get {
            return self.h
        }
    }
}

func violator(rect:Rectangle) {
    rect.width = 5
    rect.height = 4
    let area = rect.area()
    assert(area == 20, "\(area) should be equal to 20")
}

violator(rect: Square(w: 12, h: 12))

/*:
 * `violator()` malfunctions when we pass it a square
 * Since Square & Rectangle are not substitutable they violate the LSP
 * Notice that to solve this our `violator()` function would have to introspect the rect coming in and make a switch case to handle Square. This violates the OCP though because everytime we add a new case we will have to open that code. It also increases code complexity since we will most likely be switching between these shapes everywhere in our code.
 */

// Another Example adapted from https://lassala.net/2010/11/04/a-good-example-of-liskov-substitution-principle/

protocol ResourceLoaderPersister {
    func load()
    func persist()
}

struct ApplicationSettings: ResourceLoaderPersister {
    func load() {
        print("app settings loaded")
    }
    func persist() {
        print("app settings persisted")
    }
}

struct UserSettings: ResourceLoaderPersister {
    func load() {
        print("user settings loaded")
    }
    func persist() {
        print("user settings persisted")
    }
}

struct SpecialSettings: ResourceLoaderPersister {
    func load() {
        print("special settings loaded")
    }
    func persist() {
        // DON'T CALL THIS!
        fatalError()
    }
}

class MyApp {
    private let settings:[ResourceLoaderPersister]
    init(settings:[ResourceLoaderPersister]) {
        self.settings = settings
        self.loadSettings()
    }
    private func loadSettings() {
        settings.map{ $0.load()
        }
    }
    private func saveSettings() {
        for setting in settings {
            // we skip SpecialSettings
            if setting is SpecialSettings {
                continue
            }
            setting.persist()
        }
    }
}

/*:
 * What principles are violated here and why?
 * To fix this we should Create 2 separate interfaces
 */


protocol ResourceLoader {
    func load()
}

protocol ResourcePersister {
    func persist()
}


struct ApplicationSettings2: ResourceLoader, ResourcePersister {
    func load() {
        print("app settings loaded")
    }
    func persist() {
        print("app settings persisted")
    }
}

struct UserSettings2: ResourceLoader, ResourcePersister {
    func load() {
        print("user settings loaded")
    }
    func persist() {
        print("user settings persisted")
    }
}

struct SpecialSettings2: ResourceLoader {
    func load() {
        print("special settings loaded")
    }
}

class MyApp2 {
    private let settingsLoader:[ResourceLoader]
    private let settingsPersister:[ResourcePersister]
    init(settingsLoader:[ResourceLoader], settingsPersister:[ResourcePersister]) {
        self.settingsLoader = settingsLoader
        self.settingsPersister = settingsPersister
        self.loadSettings()
    }
    private func loadSettings() {
        settingsLoader.map{ $0.load()
        }
    }
    private func saveSettings() {
        settingsPersister.map{ $0.persist() }
    }
}














