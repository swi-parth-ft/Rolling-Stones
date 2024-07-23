//
//  HistoryView.swift
//  Rolling Stones
//
//  Created by Parth Antala on 2024-07-22.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) var modelContext
    @Query var histories: [History]
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.orange, .white], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                List(histories) { history in
                    VStack {
                        Text("\(history.numberOfDice) Dices Rolled")
                            .font(.headline)
                        Text("Score was \(history.totalScore)!")
                            .foregroundStyle(.secondary)
                    }
                    .listRowBackground(Color.white.opacity(0.5))
                    
                }
                .scrollContentBackground(.hidden)
            }
        }
        .navigationTitle("History")
    }
}

#Preview {
    HistoryView()
}
