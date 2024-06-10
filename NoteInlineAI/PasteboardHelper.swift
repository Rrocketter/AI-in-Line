//
//  PasteboardHelper.swift
//  NoteInlineAI
//
//  Created by Rahul Gupta on 6/7/24.
//

import Foundation

import Cocoa

class PasteboardHelper {
    static func paste(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
        
        
        let source = CGEventSource(stateID: .hidSystemState)
        let keyVDown = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: true)
        keyVDown?.flags = .maskCommand
        let keyVUp = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: false)
        keyVUp?.flags = .maskCommand
        
        let keyCmdDown = CGEvent(keyboardEventSource: source, virtualKey: 0x37, keyDown: true)
        let keyCmdUp = CGEvent(keyboardEventSource: source, virtualKey: 0x37, keyDown: false)
        
        keyCmdDown?.post(tap: .cghidEventTap)
        keyVDown?.post(tap: .cghidEventTap)
        keyVUp?.post(tap: .cghidEventTap)
        keyCmdUp?.post(tap: .cghidEventTap)
    }
}

