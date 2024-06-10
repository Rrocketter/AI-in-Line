//
//  File.swift
//  NoteInlineAI
//
//  Created by Rahul Gupta on 6/3/24.
//

import Foundation
import Cocoa

class KeyEventHandler {
    var commandBuffer = ""
    var isAICommandActive = false

    func startListening() {
        guard AccessibilityHelper.checkAccessibilityPermissions() else {
            print("Accessibility permissions are not granted.")
            return
        }

        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleKeyEvent(event)
        }
    }

    func handleKeyEvent(_ event: NSEvent) {
        guard let characters = event.charactersIgnoringModifiers else { return }

        if characters == "/" {
            commandBuffer = "/"
            isAICommandActive = true
        } else if isAICommandActive {
            if characters == "\r" {
                processCommand()
                commandBuffer = ""
                isAICommandActive = false
            } else {
                commandBuffer += characters
            }
        }
    }

    func processCommand() {
        guard commandBuffer.starts(with: "/ai") else { return }
        let prompt = String(commandBuffer.dropFirst(4))
        sendToOpenAI(prompt: prompt) { response in
            if let response = response {
                DispatchQueue.main.async {
                    self.displayResponse(response)
                }
            }
        }
    }

    func sendToOpenAI(prompt: String, completion: @escaping (String?) -> Void) {
        let apiKey = "YOUR_OPENAI_API_KEY"
        let url = URL(string: "https://api.openai.com/v1/engines/davinci-codex/completions")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = [
            "prompt": prompt,
            "max_tokens": 150
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let choices = json["choices"] as? [[String: Any]],
               let text = choices.first?["text"] as? String {
                completion(text.trimmingCharacters(in: .whitespacesAndNewlines))
            } else {
                completion(nil)
            }
        }

        task.resume()
    }

    func displayResponse(_ response: String) {
        let alert = NSAlert()
        alert.messageText = "AI Response"
        alert.informativeText = response
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}
