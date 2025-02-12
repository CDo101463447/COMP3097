import UIKit

// Exe 5.1
for i in 1...5 {
    print(i)
}

// Exe 5.2
// Define the array
let numbers = [1, 2, 3, 4, 5]

// For loop to print each value in the array
for number in numbers {
    print(number)
}

// Exe 5.3
// Define the array
let numbers = [2, 6, 11, 19, 25]

// For loop using an index to access array elements
for i in 0..<numbers.count {
    print(numbers[i])
}

// Exe 5.4
for i in 0..<numbers.count {
    print("Index: \(i), Value: \(numbers[i])")
}

// Exe 5.5
var counter = 0

while counter < 10 {
    counter += 1
    print(counter)
}

// Exe 5.6
var counter = 0

repeat {
    counter += 1
    print(counter)
} while counter < 10


// Exe 5.7
let temperature = 25

if temperature >= 30 {
    print("It's too hot")
} else if temperature < 0 {
    print("It's too cold")
} else {
    print("It's tolerable")
}

// Exe 5.8
let inputString = "1337"

if let value = Int(inputString), value == 1337 {
    print("The value is 1337")
}

// Exe 5.9
let value: Int = 1337

switch value {
case 1337:
    print("elite")
case 42:
    print("the meaning of life")
default:
    print("some number")
}

// Exe 5.10
let value: Int = 1337

switch value {
case 42, 1337, 4711:
    print("a number we care about")
default:
    print("who cares")
}

// Exe 5.11
et animal: String = "tiger"

switch animal {
case "tiger":
    print("Animal is a tiger")
    fallthrough
case "cat":
    print("Animal is a cat")
default:
    print("Animal is some other type of animal")
}

// Exe 5.12
let distance: UInt = 10

switch distance {
case 0:
    print("Here")
case 1..<5:
    print("Immediate vicinity")
case 5...15:
    print("Near")
case 16...40:
    print("Kind of far")
case _ where distance > 40:
    print("Far")
default:
    break
}

// Exe 5.13
let vector3D: (x: Int, y: Int, z: Int) = (x: 3, y: 2, z: 5)

switch vector3D {
case (x: _, y: let y, z: 5), (x: 12, y: let y, z: _):
    print(y)
default:
    break
}

// Exe 5.14
let vector3D: (x: Int, y: Int, z: Int) = (x: 3, y: 2, z: 6)

switch vector3D {
case (x: let x, y: let y, z: let z) where z == y * 3:
    print(x)
default:
    break
}

// Exe 5.15
// With 2 guards
func printIfPositiveInteger(number: String) {
    guard let value = Int(number) else { return }
    guard value > 0 else { return }
    print(value)
}

printIfPositiveInteger(number: "abc")  // No output
printIfPositiveInteger(number: "-10")  // No output
printIfPositiveInteger(number: "10")   // Output: 10

// With compund guard
func printIfPositiveInteger(number: String) {
    guard let value = Int(number), value > 0 else { return }
    print(value)
}

printIfPositiveInteger(number: "abc")  // No output
printIfPositiveInteger(number: "-10")  // No output
printIfPositiveInteger(number: "10")   // Output: 10

