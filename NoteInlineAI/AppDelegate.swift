//
//  AppDelegate.swift
//  NoteInlineAI
//
//  Created by Rahul Gupta on 6/4/24.
//

import Foundation
import Cocoa
import SwiftUI
import Quartz

class AppDelegate: NSObject, NSApplicationDelegate {
    var monitor: Any?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { (event) in
            KeyHandler.shared.handle(event: event)
        }
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        if let monitor = monitor {
            NSEvent.removeMonitor(monitor)
        }
    }
}
