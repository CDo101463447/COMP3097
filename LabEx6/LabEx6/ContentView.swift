//
//  ContentView.swift
//  LabEx6
//
//  Created by Christian Do on 2/7/25.
//

import SwiftUI

struct ContentView: View {
    @State private var count = 0
    @State private var step = 1

    var body: some View {
        VStack {
            // Title
            Text("Lab Exercise")
                .font(.title)
                .bold()
                .border(Color.black, width: 1)


            // Main UI
            VStack(spacing: 30) {
                Image("GBlogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 100)

                Text("\(count)")
                    .font(.largeTitle)
                    .frame(width: 150, height: 50)
                    .background(Color.white)

                HStack {
                    Button(action: { count -= step }) {
                        Text("-")
                            .font(.title)
                            .frame(width: 100, height: 50)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: { count += step }) {
                        Text("+")
                            .font(.title)
                            .frame(width: 100, height: 50)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }

                HStack {
                    Button(action: { count = 0 }) {
                        Text("Reset")
                            .font(.title2)
                            .frame(width: 100, height: 50)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: { step = (step == 1) ? 2 : 1 }) {
                        Text("Step = \(step)")
                            .font(.title2)
                            .frame(width: 100, height: 50)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            .background(Color.yellow.opacity(0.4))
            .border(Color.black, width: 1)
            .cornerRadius(40)
            .overlay(
                    RoundedRectangle(cornerRadius: 40)
                    .stroke(Color.black, lineWidth: 2)
            )
        }
    }
}

#Preview {
    ContentView()
}
