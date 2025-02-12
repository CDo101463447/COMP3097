import UIKit

// Exe 1
func printHelloWorld() {
    print("Hello, World!")
}

printHelloWorld()

// Exe 2
func greet(name: String) {
    print("Hello, \(name)!")
}

greet(name: "Christian Do")

// Exe 3
func greeting(name: String) -> String {
    return "Hello, \(name)!"
}

let message = greeting(name: "Christian Do")
print(message)

// Exe 4
func greet(firstName: String, lastName: String) {
    print("Hello, \(firstName) \(lastName)!")
}

greet(firstName: "Donald", lastName: "Trump")

// Exe 5
func split(name: String) -> (firstName: String, lastName: String) {
    let names = name.components(separatedBy: " ")
    
    let firstName = names.first ?? ""
    let lastName = names.dropFirst().joined(separator: " ")
    
    return (firstName, lastName)
}

split(name: "Donald Trump")
split(name: "Batman")
split(name: "")
split(name: "Dwayne \"The Rock\" Johnson")

// Exe 6
func square(_ number: Int) -> Int {
    return number * number
}

let result = square(3)
print(result)

// Exe 7
func whoAmI(name: String = "Bruce Wayne") -> String {
    if name == "Bruce Wayne" {
        return "I am Batman"
    } else {
        return "I am not Batman"
    }
}

print(whoAmI()) // Output: I am Batman
print(whoAmI(name: "Clark Kent")) // Output: I am not Batman
print(whoAmI(name: "Bruce Wayne")) // Output: I am Batman

// Exe 8
func sum(_ numbers: Int...) -> Int {
    return numbers.reduce(0, +)
}

let result1 = sum(1, 2, 3, 4, 5)
print(result1) // Output: 15

let result2 = sum(10, 20, 30)
print(result2) // Output: 60

let result3 = sum() // No arguments
print(result3) // Output: 0
