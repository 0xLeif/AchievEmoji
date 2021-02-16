//
//  ContentView.swift
//  Shared
//
//  Created by Zach Eriksen on 2/16/21.
//

import Foundation

import SwiftUI

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
    
    private var shownEmojis: [E] {
        E.allCases
            .filter { usedEmojis[$0] != nil }
            .sorted(by: { lhs,  rhs in
                (usedEmojis[lhs] ?? -1) < (usedEmojis[rhs] ?? -1)
            })
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
                    LazyVStack {
                        ForEach(shownEmojis, id: \.self) { e in
                            HStack {
                                Text(e.rawValue)
                                Text("\(String(describing: e))")
                                Spacer()
                                Text("\(usedEmojis[e] ?? 0)")
                            }
                            .foregroundColor((usedEmojis[e] ?? 0) == 0 ? .gray : .primary)
                            .padding([.leading, .trailing], 4)
                            .padding([.bottom, .top], 2)
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
                        Color.secondary
                    )
                    .cornerRadius(8)
                    .padding(32)
                    .background(
                        Color.secondary
                            .opacity(0.314)
                            .blur(radius: 4)
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
        
        isShowingCopyMessage = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isShowingCopyMessage = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
