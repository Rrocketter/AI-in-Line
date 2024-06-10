//
//  KeyHandler.swift
//  NoteInlineAI
//
//  Created by Rahul Gupta on 6/7/24.
//

import Foundation
import Cocoa

class KeyHandler {
    static let shared = KeyHandler()
    private var buffer: String = ""

    func handle(event: NSEvent) {
        if let characters = event.characters {
            if characters == "\r" || characters == "\n" {
                if buffer.hasPrefix("/ai") {
                    let prompt = String(buffer.dropFirst("/ai".count)).trimmingCharacters(in: .whitespacesAndNewlines)
                    buffer = ""
                    handleAICommand(prompt: prompt)
                } else {
                    buffer = ""
                }
            } else {
                buffer.append(characters)
            }
        }
    }

    private func handleAICommand(prompt: String) {
         OllamaService.shared.sendPrompt(prompt: prompt) { response in
            DispatchQueue.main.async {
                if let response = response {
                    PasteboardHelper.paste(response)
                } else {
                    PasteboardHelper.paste("No response received")
                }
            }
        }
    }
}



