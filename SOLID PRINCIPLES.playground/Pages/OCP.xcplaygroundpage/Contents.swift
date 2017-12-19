//: [Previous](@previous)

import UIKit

//: [Next](@next)

/*:
 ## Open-Close Principle (OCP)
 * The O.
 * "Software entities (classes, modules, functions, etc.) should be open for extension but closed for modification".
 * The idea is to write some code in such a way that it never needs to be changed but at the same time allow features to be added.
 * "Open for extention" means that we can still add behaviour to our code.
 * "Closed for modification" means we can extend without modification.
 * Abstraction and polymorphism are the key.
 * There are essentially two ways to do this: 1) using abstract base classes and inheritance, or 2) using interfaces.
 * Neither Objc nor Swift support true abstract classes or abstract methods like some languages. So, I'll just focus on interfaces instead.
 * BTW, the refactored Copy and Book examples both exhibited the open closed principle.
 * Let's look at a couple of other simple examples.
 */

// Purchase Example: Disobeys OCP


struct User { }

class Stripe1 {
  func charge(user: User, amount: Int) {
    print(#line, "stripe processing charge")
  }
}

class Purchase1 {
  private var amount: Int!
  private var stripe: Stripe1!
  
  init(stripe: Stripe1, amount: Int) {
    self.stripe = stripe
    self.amount = amount
  }
  
  func chargeUser() {
    // what if I want to use a different service?
    stripe.charge(user: User(), amount: amount!)
  }
}

// Purchase Example: Using OCP

protocol PaymentService {
  func charge(_ user: User, amount: Int)
}

class Stripe2: PaymentService {
  func charge(_ user: User, amount: Int) {
    print(#line, "stripe processing charge", amount)
  }
}

class PayPal: PaymentService {
  func charge(_ user: User, amount: Int) {
    print(#line, "Paypal processing charge", amount)
  }
}

// Purchase2 can be extended with different services without needing to modify it
class Purchase2 {
  private var amount: Int!
  private var service: PaymentService!
  
  init(service: PaymentService, amount: Int) {
    self.service = service
    self.amount = amount
  }
  
  func charge(user: User) {
    // what if I want to use a different service?
    service.charge(user, amount: amount!)
  }
}


// Example2 Shapes disobeying OCP


enum ShapeType {
  case circle, square
}

struct Circle {
  let shapeType = ShapeType.circle
  let radius: CGFloat
  let center: CGPoint
}

struct Square {
  let shapeType = ShapeType.square
  let side: CGFloat
  let point: CGPoint
}

func drawSquare(square: Square) {
  print(#line, "square drawn")
}

func drawCircle(circle: Circle) {
  print(#line, "circle drawn")
}

let c1 = Circle(radius: 20, center: .zero)
let s1 = Square(side: 29, point: .zero)
let shapes: [Any] = [c1, s1]

//: In a real application there would be many more shapes, and there would likely be switches everywhere to handle everything, which is a total nightmare especially if you have to add new shapes!

func printAllShapes(shapes: [Any]) {
  for shape in shapes {
    if shape is Circle {
      drawCircle(circle: shape as! Circle)
    } else if shape is Square {
      drawSquare(square: shape as! Square)
    }
  }
}

printAllShapes(shapes: shapes)


// Shapes with OCP

enum ShapeType2 {
  case circle, square, triangle
}

protocol Shape {
  var shapeType: ShapeType2 {
    get
  }
  func draw()
}

struct Circle2: Shape {
  let shapeType: ShapeType2 = .circle
  let radius: CGFloat
  let center: CGPoint
  func draw() {
    print("draw circle radius: \(radius), center: \(center)")
  }
}

struct Square2: Shape {
  let shapeType: ShapeType2 = .square
  let side: CGFloat
  let point: CGPoint
  func draw() {
    print("draw square side: \(side), point: \(point)")
  }
}

struct Triangle: Shape {
  // details omitted
  let shapeType: ShapeType2 = .triangle
  func draw() {
    print("draw a bunch of triangle stuff")
  }
}

let c2 = Circle2(radius: 20, center: .zero)
let s2 = Square2(side: 29, point: .zero)
let t1 = Triangle()
let shapes2: [Shape] = [c2, s2, t1]

func printAllShapes2(shapes:[Shape]) {
  // compare to line 116!
  shapes.map{ $0.draw() }
}

printAllShapes2(shapes: shapes2)


/*:
 * Uncle Bob warns agains applying "rapant abstraction to every part of the application".
 * The developer should apply abstractions judiciously to the parts of the application that exhibit frequent change.
 * Abstraction can add unnecessary complexity.
 * Question: How does the refactored Copy program obey OCP?
 */











