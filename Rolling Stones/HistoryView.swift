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
        List(histories) { history in
                VStack {
                    Text("\(history.numberOfDice)")
                        .font(.title)
                    Text("\(history.totalScore)")
                        .font(.title2)
                }
            
        }
    }
}

#Preview {
    HistoryView()
}
