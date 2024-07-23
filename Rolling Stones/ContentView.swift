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
    @State private var time = 10
    @State private var isActive = false
    
    @State private var size = 1.0
    @State private var animationAmount = 0.0
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    LinearGradient(colors: [.orange, .white], startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                    VStack {
                        Form {
                            Section {
                                //  Stepper("Number of Dice: \(numberOfDice)", value: $numberOfDice, in: 2...100)
                                
                                
                                
                                Picker("Dices", selection: $numberOfDice) {
                                    ForEach(2...100, id: \.self) {
                                        Text("\($0)")
                                    }
                                }
                                
                                Picker("Sides", selection: $numberOfSides) {
                                    ForEach(2...100, id: \.self) { i in
                                        if i % 2 == 0 {
                                            Text("\(i)")
                                        }
                                    }
                                }
                                
                                
                            }
                            .listRowBackground(Color.white.opacity(0.5))
                            .shadow(radius: 5)
                            
                        }
                        .tint(.orange)
                        .frame(height: 200)
                        .scrollContentBackground(.hidden)
                        
                        Spacer()
                        ZStack {
                            ForEach(0..<numberOfDice, id: \.self) { index in
                                Circle()
                                    .stroke(Color.orange, lineWidth: CGFloat(1 + index))
                                    .frame(width: 150)
                                    .scaleEffect(size + Double(index) / 4 + 0.2)
                                    .rotation3DEffect(.degrees(animationAmount), axis: (x: 1, y: 1, z: 0))
                                    .shadow(radius: 5)
                            }
                            
                            ZStack {
                                Circle()
                                    .fill(.orange)
                                    .frame(width: 140)
                                    .shadow(radius: 5)
                                
                                Circle()
                                    .fill(.white.opacity(0.5))
                                    .frame(width: 120)
                                    .shadow(radius: 5)
                                
                                VStack {
                                    Text("Score")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                    
                                    Text("\(totalScore)")
                                        .font(.largeTitle)
                                        .foregroundStyle(.white)
                                }
                            }
                            .scaleEffect(size + 0.1)
                            
                            .onTapGesture {
                                startRolling()
                            }
                        }
                        
                        
                        Spacer()
                        Spacer()
                        
                    }
                }
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
            .tint(.white)
            .navigationTitle("Rolling Stones")
        }
    }
    
    func startRolling() {
        time = 5
        isActive = true
        totalScore = 0
        
        roll()
        complexRoll()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
            guard isActive else { return }
            if time > 0 {
                time -= 1
                withAnimation(.smooth(duration: 1)) {
                    if size == 1 {
                        size += 0.4
                        animationAmount += 360
                    } else {
                        // size -= 0.4
                    }
                }
                
                roll()
            } else {
                timer?.invalidate()
                let history = History(numberOfDice: numberOfDice, totalScore: totalScore)
                modelContext.insert(history)
                isActive = false
                withAnimation(.smooth(duration: 1)) {
                    size = 1
                }
            }
        }
    }
    
    func roll() {
        totalScore = 0
        
        for dice in 0..<numberOfDice {
            let randomNumber = Int.random(in: 1...numberOfSides)
            print("Dice: \(dice), Number: \(randomNumber)")
            withAnimation {
                totalScore += randomNumber
            }
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

