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
                List {
                    ForEach(histories) { history in
                        VStack(alignment: .leading) {
                            Text("\(history.numberOfDice) Dices Rolled with \(history.numberOfSides) sides each")
                                .font(.headline)
                            Text("Score was \(history.totalScore)!")
                                .foregroundStyle(.secondary)
                        }
                        .listRowBackground(Color.white.opacity(0.5))
                    }
                    .onDelete(perform: deleteHistory)
                    
                    
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("History")
        }
        
        
        
    }
    func deleteHistory(at offsets: IndexSet) {
        for index in offsets {
            let history = histories[index]
            modelContext.delete(history)
        }
        
        try? modelContext.save()
    }
}

#Preview {
    HistoryView()
}
