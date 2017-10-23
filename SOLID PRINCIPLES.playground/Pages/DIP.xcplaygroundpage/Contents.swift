//: [Previous](@previous)

import Foundation

//: [Next](@next)

/*:
 ## Dependency Inversion Principle (DIP)
 * "a: High-level modules should not depend on low-level modules. Both should depend on abstractions".
 * "b: Abstractions should not depend on details. Details should depend on abstractions"
 
 * Employing DIP in OOD is important for constructing code that is more resilient to change.
 */

// Button Example not using DIP

class Lamp1 {
  // affects external environment
  // when turned on it illuminates a light of some kind & vice versa
  var isOn: Bool = false
  func turnOn() {
    isOn = true
  }
  func turnOff() {
    isOn = false
  }
}

class Button1 {
  // senses the external environment, could be a physical button, a gui button, or even a motion detector
  private let lamp: Lamp1
  init(lamp: Lamp1) {
    self.lamp = lamp
  }
  
  func poll() {
    // determine whether the button was pressed
    let didPress = arc4random_uniform(1) == 1 ? true : false
    if didPress {
      lamp.turnOn()
    } else {
      lamp.turnOff()
    }
  }
}

/*:
 * "DIP can be applied whenever one class sends a message to another"
 * We can see that Button has a concrete dependency on Lamp.
 * Button sends a message to Lamp.
 * The problem is the Button object would be affected if there were changes to the signature of methods it called on the Lamp object.
 * The Button object cannot be reused to control, say, the Motor object.
 * Button objects control Lamps & only Lamps.
 * The "high-level policy" of the program hasn't been separated from the "low-level implementation".
 * The "high-level policy" or "underlying abstraction" of our program is to "detect an on/off gesture from a user and relay that gesture to a target object. What mechanism is used to detect the user gesture? Irrelevant! What is the target object? Irrelevant! These are details that do not impact the abstraction".
 * What we want to avoid is making this "high-level policy" (abstract) depend on something that is too concrete, such as the Lamp.
 */


// Button Example using DIP

protocol ButtonServer {
  func turnOn()
  func turnOff()
}

class Lamp2: ButtonServer {
  var isOn: Bool = false
  func turnOn() {
    isOn = true
  }
  func turnOff() {
    isOn = false
  }
}

class Button2 {
  
  private let server: ButtonServer
  
  init(server: ButtonServer) {
    self.server = server
  }
  
  func poll() {
    // determine whether the button was pressed
    let didDetectGesture = arc4random_uniform(1) == 1 ? true : false
    if didDetectGesture {
      server.turnOn()
    } else {
      server.turnOff()
    }
  }
}

/*:
 * The Lamp is now dependent on an abstraction, the ButtonServer, and so is the Button object.
 * We can easily have another output device that implements ButtonServer.
 * Here I'm imagining that the Motor object itself is something I cannot alter. That is, I cannot change its interface. 
 * So, I've created an Adapter object that implements the protocol and calls into the Motor object. In Swift we would use an extension for this.
 */

class Motor {
  // Motor specific methods I can't change
  func motorOn() {}
  func motorOff() {}
}

// classical Adapter Pattern
class MotorAdapter: ButtonServer {
  private let motor: Motor
  init(motor: Motor) {
    self.motor = motor
  }
  func turnOn() {
    self.motor.motorOn()
  }
  func turnOff() {
    self.motor.motorOff()
  }
}

// Same thing with an extension in Swift (Cool!)

extension Motor: ButtonServer {
  func turnOn() {
    self.motorOn()
  }
  func turnOff() {
    self.motorOff()
  }
}

/*:
 
 * So, Button depends on ButtonServer, and Lamp depends on ButtonServer, which is an abstraction.
 * ButtonServer itself doesn't have any dependencies.
 * Both Button and Lamp depend on an abstraction.
 * We could change the name "ButtonServer" to something more generic, like "SwitchableServer", since not just Buttons could use it, any switch could. We could also generalize Button to adopt something like a Switchable interface if we wanted our program to work with other event creators, like for instance a motion detector.
 * It might not help to talk about "inverted dependencies". Just think about the idea that policies in your code that are actually quite abstract, shouldn't have concrete dependencies. Abstract policies should depend on abstractions not on concrete objects.
 * DIP is the hallmark of good OOD.
 
 */

//: ![](dip.png)






