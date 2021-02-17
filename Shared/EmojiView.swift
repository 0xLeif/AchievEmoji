//
//  EmojiView.swift
//  AchievEmoji
//
//  Created by Zach Eriksen on 2/16/21.
//

import Foundation

import SwiftUI

import EKit

#if os(iOS)
import UIKit
#endif

struct EmojiView: View {
    
    let emoji: E
    let count: Int
    
    
    var body: some View {
        
        HStack {
            Text(emoji.rawValue)
            Text("\(String(describing: emoji))")
            Spacer()
            Text("\(count)")
        }
        .foregroundColor(count == 0 ? .gray : .primary)
        .padding([.leading, .trailing], 4)
        .padding([.bottom, .top], 2)
    }
}

struct EmojiView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiView(emoji: .abacus, count: 3)
    }
}
