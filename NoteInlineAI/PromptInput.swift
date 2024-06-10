//
//  PromptInput.swift
//  NoteInlineAI
//
//  Created by Rahul Gupta on 6/7/24.
//

import Foundation
import Cocoa


class PromptInput {
    static func getPrompt(from input: String) -> String? {
        
        return input.isEmpty ? nil : input
    }
}
