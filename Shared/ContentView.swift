//
//  ContentView.swift
//  Shared
//
//  Created by Zach Eriksen on 2/16/21.
//

import Foundation

import SwiftUI
import Combine
import Combino

import EKit

#if os(iOS)
import UIKit
#endif

struct ContentView: View {
    @State private var usedEmojis: [E: Int] = [
        .abacus: 3,
        .smiling_face: 23
    ]
    
    @State private var searchText = ""
    @State private var lastUsedEmoji: E?
    
    @State private var isShowingCopyMessage = false
    
    @State private var task: AnyCancellable?
    
    private var shownEmojis: [E] {
        E.allCases
            .filter { usedEmojis[$0] != nil }
            .sorted(by: { lhs,  rhs in
                (usedEmojis[lhs] ?? -1) > (usedEmojis[rhs] ?? -1)
            })
    }
    
    private var unusedEmojis: [E] {
        E.allCases
            .filter { usedEmojis[$0] == nil }
    }
    
    private var randomlySearchedEmoji: E? {
        let text = searchText.lowercased().replacingOccurrences(of: " ", with: "_")
        let emojis = E.allCases.filter { String(describing: $0).contains(text) }
        
        return emojis.randomElement()
    }
    
    var body: some View {
        ZStack {
            
            VStack {
                ScrollView {
                    Spacer()
                        .frame(width: 16, height: 16, alignment: .center)
                    if !usedEmojis.isEmpty {
                        Text("Used Emojis")
                        
                        LazyVStack {
                            ForEach(shownEmojis, id: \.self) { e in
                                EmojiView(emoji: e, count: usedEmojis[e] ?? 0)
                            }
                        }
                    }
                    
                    Text("Unused Emojis")
                    
                    LazyVStack {
                        ForEach(unusedEmojis, id: \.self) { e in
                            EmojiView(emoji: e, count: 0)
                        }
                    }
                    
                }
                
                VStack {
                    TextField("Search",
                              text: $searchText,
                              onCommit:  {
                                loadRandomEmoji()
                              })
                    
                    Button("Find") {
                        loadRandomEmoji()
                    }
                }
                .padding()
            }
            
            if let lastUsedEmoji = lastUsedEmoji,
               isShowingCopyMessage {
                Text("Copied \(lastUsedEmoji.rawValue)")
                    .font(.title)
                    .foregroundColor(Color.black)
                    .padding()
                    .background(
                        Color.white
                    )
                    .cornerRadius(8)
            }
        }
    }
    
    private func loadRandomEmoji() {
        guard let randomlySearchedEmoji = randomlySearchedEmoji else {
            return
        }
        
        lastUsedEmoji = randomlySearchedEmoji
        
        print("Random Emoji: \(randomlySearchedEmoji.rawValue)")
        
        if let usage = usedEmojis[randomlySearchedEmoji] {
            usedEmojis[randomlySearchedEmoji] = usage + 1
        } else {
            usedEmojis[randomlySearchedEmoji] = 1
        }
        
        #if os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(randomlySearchedEmoji.rawValue, forType: .string)
        #else
        UIPasteboard.general.string = randomlySearchedEmoji.rawValue
        #endif
        
        task?.cancel()
        isShowingCopyMessage = true
        task = Combino.do(withDelay: 1, work: { })
            .sink(
                .success {
                    DispatchQueue.main.async {
                        isShowingCopyMessage = false
                    }
                }
            )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
