//
//  PagingView.swift
//  Thesaurus App
//
//  Created by Malachi on 1/25/24.
//

import SwiftUI

struct PagingView: View {
    let words: [String]
    
    @State private var page: Int = 1
    
    var pages: Int {
        let addition = if words.count % ContentView.pageSize >= 1 {
            1
        } else {
            0
        }
        return (words.count / ContentView.pageSize) + addition
    }
    
    var allWords: [String] {
        let startIndex = (page - 1) * ContentView.pageSize
        let endIndex = min(page * ContentView.pageSize, words.count)
        return Array(words[startIndex..<endIndex])
    }
    
    var body: some View {
        ScrollView {
            if words.count >= ContentView.pageSize {
                Text("\(page)/\(pages)")
                    .font(.caption)
            }
            buttons
            ForEach(allWords, id: \.self, content: ContentView.wordView)
            buttons
        }
    }
    
    @ViewBuilder var buttons: some View {
        if words.count >= ContentView.pageSize {
            HStack {
                Button {
                    if page > 1 {
                        page -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                }
                Button {
                    if page < pages {
                        page += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
        }
    }
}
