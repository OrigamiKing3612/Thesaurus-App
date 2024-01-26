//
//  Thesaurus_AppApp.swift
//  Thesaurus App
//
//  Created by Malachi on 1/25/24.
//

import SwiftUI
import Observation

@main
struct Thesaurus_AppApp: App {
    @State private var clipboardContent: String = ""
        
    var body: some Scene {
        MenuBarExtra {
            ContentView()
            Divider()
            ButtonWithShortcut("Quit", "q") {
                NSApplication.shared.terminate(nil)
            }
        } label: {
            Image(systemName: "book.closed")
                .font(.largeTitle)
        }
//        .defaultSize(width: 600, height: 400)
        .windowResizability(.contentSize)
        .menuBarExtraStyle(.window)
    }
}

struct ButtonWithShortcut: View {
    let title: String
    let shortcut: Character
    let action: () -> Void
        
    var body: some View {
        HStack {
            Button(title) {
                action()
            }
            .keyboardShortcut(KeyEquivalent(shortcut))
            Spacer()
            HStack(spacing: 0) {
                Image(systemName: "command")
                Text("\(String(shortcut).uppercased())")
            }
            .foregroundStyle(.gray)
        }
        .padding(.horizontal)
    }
    init(_ title: String, _ shortcut: Character, _ action: @escaping () -> Void) {
        self.title = title
        self.shortcut = shortcut
        self.action = action
    }
}

public class Window {
    public let width: Int
    public let height: Int
    
    
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
}
