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
        hotKey = HotKey(keyCombo: KeyCombo(key: .space, modifiers: [.shift]))
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        hotKey = nil
    }
}
