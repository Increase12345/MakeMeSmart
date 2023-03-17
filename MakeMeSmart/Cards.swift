//
//  Cards.swift
//  MakeMeSmart
//
//  Created by Nick Pavlov on 3/16/23.
//

import Foundation

@MainActor class Cards: ObservableObject {
    @Published var allCards = [Card]()
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("Cards")
    
    func loadData() {
        do {
            let data = try Data(contentsOf: savePath)
            allCards = try JSONDecoder().decode([Card].self, from: data)
        } catch {
            allCards = []
        }
    }
    
    func saveData() {
        do {
            let data = try JSONEncoder().encode(allCards)
            try data.write(to: savePath)
        } catch {
            print("Can't save files \(error.localizedDescription)")
        }
    }
}
