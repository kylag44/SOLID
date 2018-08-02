//: [Previous](@previous)

import Foundation

//: [Next](@next)

/*:
 ## Interface Segregation Principle (ISP)
 * The I.
 * "Clients should not be forced to depend on methods that they do not use"
 * This is not really a problem in either Objc or Swift since we don't have abstract classes, although we could end up littering our code with a lot of optional protocol methods. Does Swift allow optional protocol methods?
 * Here's the general idea:
 */

class Duck {
  // abstract method
  func fly() {
    fatalError("must override")
  }
}

class Mallard: Duck {
  override func fly() {
    print(#line, "Mallards can fly!")
  }
}

class Decoy: Duck {
  override func fly() {
    // Decoy is forced to depend on `fly()` even though it does not need this method.
    //    fatalError()
  }
}

let d1 = Mallard()
let d2 = Decoy()
d1.fly()
d2.fly()

//: If we throw an error then we might want to add some logic to check to make sure the underlying object isn't a Decoy object.
//: Why is this a bad solution?

let ducks = [d1, d2]

for duck in ducks {
  if duck is Decoy {
    continue
  }
  duck.fly()
}

//: What other SOLID principles are we violating here?


/*:
 * Decoy is forced to depend on its super class's abstract fly() method even though it doesn't implement fly() (it's forced to implement it and it does nothing 😭😡).
 * The problem with this is that if the interface's signature were to change, then it would break our Decoy Duck even though it doesn't even need this method! This makes our program unnecessarily fragile in the face of change.
 * The solution to this is to create a separate interface for Flyable and only have Mallard conform and not Decoy.
 * This is "composition over inheritance". We create objects by composing them of select behaviors rather than inherit these.
 */

//: Move the method out of Duck and into an interface.

class Duck2 { }

protocol Flyable {
  func fly()
}

class Mallard2: Duck2, Flyable {
  func fly() {
    print("yay, I can fly!")
  }
}

/*:
 * What's the problem with this solution?
 * How does Swift solve this?
 */

extension Flyable {
  func fly() {
    print("this is default behaviour")
  }
}

class CanadaGoose: Duck2, Flyable {
  // if we don't implement fly() it gets the default implementation from the Flyable extension! 🆒
}

class RubberDuck: Duck2 {
  // doesn't conform
}

let cg = CanadaGoose()
cg.fly()
let rd = RubberDuck()
// rd.fly() // It can't fly, so doesn't implement the fly() method









