//: [Previous](@previous)

import UIKit

//: [Next](@next)

/*:
## Open-Close Principle (OCP)
 * "Software entities (classes, modules, functions, etc.) should be open for extension but closed for modification"
 * The idea is to write code in such a way that it never needs to be changed even though features can still be added
 * Programs that exhibit rigidity require a cascade of changes on dependent entities when a single change is made
 * OCP advises us to refactor our code to protect further changes of the kind from requiring modifications to dependent entities
 * "Open for extention" means that we can add behaviour to our code
 * "Closed for modification" means we don't have to modify dependent entities.
 * Abstraction and polymorphism are the key
 * There are essentially two ways to do this: 1) using abstract base classes and inheritance, and 2) using interfaces
 * Neither Objc nor Swift support abstract classes or abstract methods like some languages. So, I'll just focus on interfaces instead.
 * BTW, the Copy and Book examples exhibited the open closed principle
 * Let's look at a couple of other simple examples.
 */

// Purchase Example: Disobeys OCP


struct User { }

class Stripe1 {
    func charge(user:User, amount: Int) {
        print("stripe processing charge")
    }
}

class Purchase1 {
    private var amount: Int!
    private var stripe: Stripe1!
    
    init(stripe:Stripe1, amount: Int) {
        self.stripe = stripe
        self.amount = amount
    }
    
    func chargeUser() {
        // what if I want to use a different service?
        stripe.charge(User(), amount: amount!)
    }
}

// Purchase Example: Using OCP

protocol PaymentService {
    func charge(user:User, amount:Int)
}

class Stripe2: PaymentService {
    func charge(user:User, amount: Int) {
        print("stripe processing charge")
    }
}

class PayPal: PaymentService {
    func charge(user: User, amount: Int) {
        print("Paypal processing charge")
    }
}

// Purchase2 can be extended without needing to modify it
class Purchase2 {
    private var amount: Int!
    private var service: PaymentService!
    
    init(service:PaymentService, amount: Int) {
        self.service = service
        self.amount = amount
    }
    
    func chargeUser() {
        // what if I want to use a different service?
        service.charge(User(), amount: amount!)
    }
}


// Example2 Shapes disobeying OCP


enum ShapeType {
    case Circle, Square
}

struct Circle {
    let shapeType = ShapeType.Circle
    let radius: CGFloat
    let center: CGPoint
}

struct Square {
    let shapeType = ShapeType.Square
    let side: CGFloat
    let point: CGPoint
}

func drawSquare(square:Square) {
    print("square drawn")
}

func drawCircle(circle:Circle) {
    print("circle drawn")
}

let c1 = Circle(radius: 20, center: CGPointZero)
let s1 = Square(side: 29, point: CGPointZero)
let shapes:[Any] = [c1, s1]

// in a real application there would be many more shapes, and there would likely be switches everywhere to handle everything, which is a total nightmare especially if you have to add a new shape!

func printAllShapes(shapes:[Any]) {
    for shape in shapes {
        if shape is Circle {
            drawCircle(shape as! Circle)
        } else if shape is Square {
            drawSquare(shape as! Square)
        }
    }
}

printAllShapes(shapes)


// Shapes with OCP

enum ShapeType2 {
    case Circle, Square, Triangle
}

protocol Shape {
    var shapeType: ShapeType2 {
        get
    }
    func draw()
}

struct Circle2: Shape {
    let shapeType = ShapeType2.Circle
    let radius: CGFloat
    let center: CGPoint
    func draw() {
        print("draw circle radius: \(radius), center: \(center)")
    }
}

struct Square2: Shape {
    let shapeType = ShapeType2.Square
    let side: CGFloat
    let point: CGPoint
    func draw() {
        print("draw square side: \(side), point: \(point)")
    }
}

struct Triangle: Shape {
    // details omitted
    let shapeType: ShapeType2 = ShapeType2.Triangle
    func draw() {
        print("draw a bunch of triangle stuff")
    }
}

let c2 = Circle2(radius: 20, center: CGPointZero)
let s2 = Square2(side: 29, point: CGPointZero)
let t1 = Triangle()
let shapes2:[Shape] = [c2, s2, t1]

func printAllShapes2(shapes:[Shape]) {
    // compare to line 116!
    shapes.map{ $0.draw() }
}

printAllShapes2(shapes2)


/*:
 * Uncle Bob warns agains applying "rapant abstraction to every part of the application".
 * The developer should apply abstraction judiciously to the parts of the application that exhibit frequent change.
 * Abstraction can add unnecessary complexity
 * Is it true that frequent change should be the only axis that determines our use of abstractions?
 */

/*:
 * Final example of OCP
 */

protocol DataPasserInterface {
    func dataPasser(data:AnyObject)
}

class MyDestinationVC: UIViewController, DataPasserInterface {
    
    private var data:AnyObject?
    
    func dataPasser(data: AnyObject) {
        self.data = data
    }
}

// This

class MyVC: UIViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! DataPasserInterface
        vc.dataPasser("some data passed in")
    }
}











