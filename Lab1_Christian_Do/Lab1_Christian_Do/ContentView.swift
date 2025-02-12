import SwiftUI

struct ContentView: View {
    @State private var number = Int.random(in: 1...100)
    @State private var correctAnswers = 0
    @State private var wrongAnswers = 0
    @State private var attempts = 0
    @State private var showResultDialog = false
    @State private var isCorrect: Bool? = nil
    
    @State private var timer: Timer?
    @State private var timeRemaining = 5  // Timer countdown
    
    @State private var gameStarted = false
    @State private var gameEnded = false // Track if game is ended
    
    var body: some View {
        VStack {
            // Start Button
            Button(action: startGame) {
                Text(gameStarted ? "Restart Game" : "Start Game")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            // Timer Display
            if gameStarted && !gameEnded {
                Text("Time Remaining: \(timeRemaining)s")
                    .font(.title2)
                    .padding()
            }
            
            if gameStarted && !gameEnded {
                Text("Is this number prime?")
                    .font(.title2)
                    .padding()
                
                Text("\(number)")
                    .font(.system(size: 50, weight: .bold))
                    .padding()
                
                HStack {
                    Button(action: { checkAnswer(isPrime: true) }) {
                        Text("Prime")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: { checkAnswer(isPrime: false) }) {
                        Text("Not Prime")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                
                // Show the correct or incorrect icon after selection
                if let correct = isCorrect {
                    Image(systemName: correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(correct ? .green : .red)
                        .transition(.opacity)
                        .onAppear {
                            // Delay resetting the icon
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                nextNumber()
                            }
                        }
                }
            }
            
            // Show result dialog after 10 attempts
            if gameEnded {
                Text("Game Over!")
                    .font(.title)
                    .foregroundColor(.red)
                Text("Correct: \(correctAnswers)\nWrong: \(wrongAnswers)")
                    .font(.title2)
                    .padding()
            }
        }
        .onAppear(perform: startTimer)
        .alert(isPresented: $showResultDialog) {
            Alert(
                title: Text("Results"),
                message: Text("Correct: \(correctAnswers)\nWrong: \(wrongAnswers)"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func startGame() {
        gameStarted = true
        gameEnded = false // Reset gameEnded when starting the game
        attempts = 0
        correctAnswers = 0
        wrongAnswers = 0
        timeRemaining = 5  // Reset timer
        nextNumber()  // Start the first round
    }
    
    func checkAnswer(isPrime: Bool) {
        if !gameEnded {
            if isPrime == isNumberPrime(number) {
                correctAnswers += 1
                isCorrect = true
            } else {
                wrongAnswers += 1
                isCorrect = false
            }
        }
    }
    
    func nextNumber() {
        if attempts >= 10 {
            gameEnded = true
            showResultDialog = true
            stopTimer() // Stop the timer when the game ends
            return
        }
        
        attempts += 1
        number = Int.random(in: 1...100)
        isCorrect = nil
        resetTimer()
    }
    
    func startTimer() {
        if !gameEnded {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if gameStarted && !gameEnded && timeRemaining > 0 {
                    timeRemaining -= 1
                } else if timeRemaining == 0 {
                    wrongAnswers += 1
                    nextNumber()
                }
            }
        }
    }
    
    func resetTimer() {
        timeRemaining = 5  // Reset timer to 5 seconds
        timer?.invalidate()  // Stop the old timer
        startTimer()  // Start the new timer
    }
    
    func stopTimer() {
        timer?.invalidate()  // Ensure the timer stops when game ends
    }
    
    func isNumberPrime(_ n: Int) -> Bool {
        guard n > 1 else { return false }
        let limit = Int(sqrt(Double(n))) + 1
        for i in 2..<limit {
            if n % i == 0 { return false }
        }
        return true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
