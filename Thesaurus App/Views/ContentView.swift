//
//  ContentView.swift
//  Thesaurus App
//
//  Created by Malachi on 1/25/24.
//

import SwiftUI

struct ContentView: View {
    static let pageSize = 5

    var clipboard: String {
        readClipboard()
    }
    
    @State private var allSynonyms = [String]()
    @State private var allAntonyms = [String]()
    
    var body: some View {
        HStack {
            VStack {
                Text("\(clipboard)")
                    .font(.caption)
                    .lineLimit(3)
                    .truncationMode(.middle)
                    .onAppear {
                        Task {
                            let word = await ServerAPI.shared.fetch(word: clipboard)
                            if let word = word {
                                self.allSynonyms = word.synonyms
                                self.allAntonyms = word.antonyms
                            } else {
                                self.allSynonyms = ["An Error Occurred"]
                                self.allAntonyms = ["An Error Occurred"]
                            }
                        }
                    }
            }
            HStack {
                VStack {
                    Text("Synonyms")
                        .font(.caption)
                    PagingView(words: synonyms)
                }
                Spacer()
                VStack {
                    Text("Antonyms")
                        .font(.caption)
                    PagingView(words: antonyms)
                }
            }
            .padding()
        }
    }
    public static func wordView(_ word: String) -> some View {
        HStack {
            Text(word)
                .font(.caption)
            Spacer()
            Button {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(word, forType: .string)
            } label: {
                Image(systemName: "clipboard")
                    .font(.caption)
            }
        }
    }
    var synonyms: [String] {
        self.allSynonyms
            .removeDuplicates()
            .sorted(by: <)
    }
    var antonyms: [String] {
        self.allAntonyms
            .removeDuplicates()
            .sorted(by: <)
    }
    private func readClipboard() -> String {
        guard let clipboardString = NSPasteboard.general.string(forType: .string) else {
            return "Error reading clipboard"
        }
        return clipboardString
    }
}

extension Array where Element: Equatable {
    public func removeDuplicates() -> [Element] {
        self.reduce(into: [Element]()) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
}
