//
//  ContentView.swift
//  Rolling Stones
//
//  Created by Parth Antala on 2024-07-22.
//
import CoreHaptics
import SwiftData
import SwiftUI

import CoreHaptics
import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var numberOfDice = 2
    @State private var numberOfSides = 6
    @State private var totalScore = 0
    
    @State private var isShowingHostory = false
    
    @State private var engine: CHHapticEngine?
    
    @State private var timer: Timer?
    @State private var time = 5
    @State private var isActive = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Stepper("Number of Dice: \(numberOfDice)", value: $numberOfDice)
                    
                    Stepper {
                        numberOfSides += 2
                    } onDecrement: {
                        numberOfSides -= 2
                    } label: {
                        Text("Number of Sides: \(numberOfSides)")
                    }
                    
                    Button("Roll") {
                        startRolling()
                    }
                    
                }
                
                Text("Your Score is: \(totalScore)")
                    .font(.headline)
            }
            .toolbar {
                Button("History", systemImage: "clock") {
                    isShowingHostory = true
                    
                }
                .onAppear {
                    prepareHaptics()
                }
            }
            .sheet(isPresented: $isShowingHostory) {
                HistoryView()
            }
        }
    }
    
    func startRolling() {
        time = 5
        isActive = true
        totalScore = 0
        
        roll()
        complexRoll()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            guard isActive else { return }
            if time > 0 {
                time -= 1
                roll()
            } else {
                timer?.invalidate()
                let history = History(numberOfDice: numberOfDice, totalScore: totalScore)
                modelContext.insert(history)
                isActive = false
            }
        }
    }
    
    func roll() {
        totalScore = 0
        
        for dice in 0..<numberOfDice {
            let randomNumber = Int.random(in: 1...numberOfSides)
            print("Dice: \(dice), Number: \(randomNumber)")
            totalScore += randomNumber
        }
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Can not create the engine")
        }
    }
    
    func complexRoll() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }
        
        var events = [CHHapticEvent]()
        
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }
        
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 + i)
            events.append(event)
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern")
        }
    }
}

#Preview {
    ContentView()
}

