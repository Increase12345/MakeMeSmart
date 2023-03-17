//
//  Card.swift
//  MakeMeSmart
//
//  Created by Nick Pavlov on 3/16/23.
//

import Foundation

struct Card: Codable, Identifiable {
    var id = UUID()
    var prompt: String
    var answer: String
    
    static let example = Card(prompt: "Who was the first president?", answer: "George Washington")
}
