//
//  ContentView.swift
//  Lab1_Christian_Do
//
//  Created by Christian Do on 2/11/25.
//

import SwiftUI

struct ContentView: View {
    @State private var number = Int.random(in: 1...100)
    @State private var correctAnswers = 0
    @State private var wrongAnswers = 0
    @State private var attempts = 0
    @State private var showResultDialog = false
    @State private var isCorrect: Bool? = nil
    
    @State private var timer: Timer?
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
