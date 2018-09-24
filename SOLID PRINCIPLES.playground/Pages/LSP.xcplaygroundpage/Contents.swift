//: [Previous](@previous)

import Foundation

//: [Next](@next)

//: ![](lsp.jpg)

/*:
 ## Liskov Substitution Principle
 * The L.
 * "Subtypes must be substitutable for their base types."
 * General idea:
 * I have a function that takes a parameter of a specific type. I pass in an upcast object. But this upcast object causes some unexpected behaviour inside the function because there is a violation of LSP.
 * Eg.
 */

class BaseClass { }
class DerivedClass: BaseClass {}
func f(x: BaseClass) {}
f(x: DerivedClass()) // calling f(x:) with the subtype causes  misbehavior

// Square / Rectangle Classic Example

class Rectangle {
  // stored
  internal var _width: Int
  internal var _height: Int
  
  // computed
  var width: Int {
    get {
      return self._width
    }
    set {
      self._width = newValue
    }
  }
  
  var height: Int {
    get {
      return self._height
    }
    set {
      self._height = newValue
    }
  }
  
  init(width: Int, height: Int){
    self._width = width
    self._height = height
  }
  
  func area()-> Int {
    return self._width * self._height
  }
}

class Square: Rectangle {
  override var width: Int {
    set {
      self._width = newValue
      self._height = newValue
    }
    get {
      return self._width
    }
  }
  override var height: Int {
    set {
      self._height = newValue
      self._width = newValue
    }
    get {
      return self._height
    }
  }
}

func violator(rect: Rectangle) {
  rect.width = 5
  rect.height = 4
  let area = rect.area()
  assert(area == 20, "\(area) should be equal to 20")
}

// violator(rect: Square(width: 12, height: 12))

/*:
 * `violator()` malfunctions when we pass it a square.
 * Since Square & Rectangle are not substitutable they violate the LSP.
 * Notice that to solve this our `violator()` function would have to introspect the rect coming in and make a switch case to handle Square.
 * This violates the OCP though because every time we add a new case we will have to open that code.
 * It also increases code complexity since we will most likely be switching between these shapes everywhere in our code.
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
    // DON'T CALL THIS! Idiot!
    fatalError()
  }
}

class MyApp {
  private let settings: [ResourceLoaderPersister]
  init(settings: [ResourceLoaderPersister]) {
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
  private let settingsLoader: [ResourceLoader]
  private let settingsPersister: [ResourcePersister]
  init(settingsLoader: [ResourceLoader], settingsPersister: [ResourcePersister]) {
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














