//
//  ContentView.swift
//  MakeMeSmart
//
//  Created by Nick Pavlov on 3/16/23.
//

import SwiftUI

extension View {
    func stacked(at position: Int, total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

struct ContentView: View {
    @StateObject private var cards = Cards()
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var showingEditCards = false
    @State private var timeRemaining = 100
    @State private var isActive = true
    
    var body: some View {
        ZStack {
            
            // Background picture
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            // Time counting
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .foregroundColor(.white)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                
                // Cards view
                ZStack {
                    ForEach(0..<cards.allCards.count, id: \.self) { index in
                        CardView(card: cards.allCards[index]) {
                            withAnimation {
                                removeCard(at: index)
                            }
                        }
                        .stacked(at: index, total: cards.allCards.count)
                        .allowsHitTesting(index == cards.allCards.count - 1)
                        .accessibilityHidden(index < cards.allCards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                // Button to start over if there is no cards
                if cards.allCards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                        .padding()
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    // Button to toggle edit and add new cards view
                    Button {
                        showingEditCards = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.75))
                            .clipShape(Circle())
                    }
                }
                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            // Performing accessibility features
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            withAnimation {
                                removeCard(at: cards.allCards.count - 1)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect")
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                removeCard(at: cards.allCards.count - 1)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer is being correct")
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        
        // Catching timer if screen is active
        .onReceive(timer) { time in
            guard isActive else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        
        // Catching activity of the screen
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if cards.allCards.isEmpty == false {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        
        // Edit and add cards View
        .sheet(isPresented: $showingEditCards) {
            EditCards(cards: cards)
        }
        .onAppear(perform: resetCards)
    }
    
    func resetCards() {
        timeRemaining = 100
        isActive = true
        cards.loadData()
        
    }
    
    func removeCard(at index: Int) {
        guard index >= 0 else { return }
        cards.allCards.remove(at: index)
        
        if cards.allCards.isEmpty {
            isActive = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
