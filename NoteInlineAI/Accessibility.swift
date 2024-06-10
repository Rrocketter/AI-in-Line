//
//  Accessibility.swift
//  NoteInlineAI
//
//  Created by Rahul Gupta on 6/3/24.
//

import Cocoa

class AccessibilityHelper {
    static func requestAccessibilityPermissions() {
        let alert = NSAlert()
        alert.messageText = "Accessibility Permissions Required"
        alert.informativeText = "Please grant accessibility permissions to this app in System Preferences > Security & Privacy > Accessibility."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()

        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
        NSWorkspace.shared.open(url)
    }
    
    static func checkAccessibilityPermissions() -> Bool {
        return AXIsProcessTrustedWithOptions([kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary)
    }
}

