//
//  EditCards.swift
//  MakeMeSmart
//
//  Created by Nick Pavlov on 3/16/23.
//

import SwiftUI

struct EditCards: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var cards: Cards
    
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    
    var body: some View {
        NavigationStack {
            List {
                
                // Section with fields for adding a new card
                Section("Add new card") {
                    TextField("Prompt", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Button("Add") {
                        addCard()
                    }
                }
                
                // Section with list of all existing cards
                Section("List of cards") {
                    ForEach(0..<cards.allCards.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(cards.allCards[index].prompt)
                                .font(.headline)
                            Text(cards.allCards[index].answer)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)
                }
            }
            .navigationTitle("Edit Cards")
            
            // Done and go back button
            .toolbar {
                Button("Done", action: done)
            }
            .listStyle(.grouped)
            
        }
    }
    
    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }
        
        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        cards.allCards.insert(card, at: 0)
        cards.saveData()
        
        newPrompt = ""
        newAnswer = ""
        dismiss()
    }
    
    func removeCards(at offsets: IndexSet) {
        cards.allCards.remove(atOffsets: offsets)
        cards.saveData()
    }
    
    func done() {
        dismiss()
    }
}

struct EditCards_Previews: PreviewProvider {
    static var previews: some View {
        EditCards(cards: Cards())
    }
}
