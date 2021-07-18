//
//  AppDelegate.swift
//  keyboardConverter
//
//  Created by 김동호 on 2021/07/18.
//

import Cocoa
import Carbon
import HotKey

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private var hotKey: HotKey? {
        didSet {
            guard let hotKey = hotKey else {
                return
            }
            
            hotKey.keyDownHandler = {
                print("Pressed at \(Date())")
            }
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        constructMenu()
        hotKey = HotKey(keyCombo: KeyCombo(key: .space, modifiers: [.shift]))
    }
    
    func constructMenu() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
        statusItem.button?.image = #imageLiteral(resourceName: "StatusBarIcon")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        hotKey = nil
    }
}
