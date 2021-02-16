# AchievEmoji

## POC

```swift
import Foundation

import SwiftUI

import EKit

struct ContentView: View {
    @State private var usedEmojis: [E: Int] = [
        .abacus: 3,
        .smiling_face: 23
    ]
    
    @State private var searchText = ""
    
    var shownEmojis: [E] {
        E.allCases
            .filter { usedEmojis[$0] != nil }
            .sorted(by: { lhs,  rhs in
                (usedEmojis[lhs] ?? -1) < (usedEmojis[rhs] ?? -1)
            })
    }
    
    var body: some View {
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
            
            TextField("Search", text: $searchText) {
                print(E.allCases.first(where: {
                    String(describing: $0).contains(searchText)
                }))
            }
            .padding()
        }
    }
}
```
