//
//  VirtualKeyManager.swift
//  keyboardConverter
//
//  Created by 김동호 on 2021/07/19.
//

import Cocoa
import Sauce

class VirtualKeyManager {
    
    private var timer: Timer? = nil
    
    private func cmdKeyEvent(virtualKey: CGKeyCode, flags: CGEventFlags?, keyDown: Bool) {
        guard let event = CGEvent(keyboardEventSource: nil, virtualKey: virtualKey, keyDown: keyDown) else { return }
        if let flags = flags {
            event.flags = flags
        }
        event.post(tap: .cghidEventTap)
    }
    private func cmdKeyEvent(virtualKey: CGKeyCode, flags: CGEventFlags? = nil) {
        cmdKeyEvent(virtualKey: virtualKey, flags: flags, keyDown: true)
        cmdKeyEvent(virtualKey: virtualKey, flags: flags, keyDown: false)
    }
    private func copyCurrentLine() {
        cmdKeyEvent(virtualKey: Sauce.shared.keyCode(for: .leftArrow), flags: .maskCommand)
        cmdKeyEvent(virtualKey: Sauce.shared.keyCode(for: .rightArrow), flags: [.maskCommand, .maskShift])
        cmdKeyEvent(virtualKey: Sauce.shared.keyCode(for: .c), flags: .maskCommand)
    }
    
    private func getPasteboardString() -> String {
        return NSPasteboard.general.string(forType: .string) ?? ""
    }
    private func convert(src: String) -> String {
        return src + " tested"
    }
    private func setPasteboardString(dst: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(dst, forType: .string)
    }
    
    private func pollingCopyCompleted(src: String, completion: @escaping (String) -> Void) {
        var count = 0
        let timeout = 5
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            count += 1
            if count > timeout {
                timer.invalidate()
                return
            }
            
            let dst = self.getPasteboardString()
            if src == dst {
                return
            }
            timer.invalidate()
            completion(dst)
        }
        timer?.fire()
    }
    
    private func convertPaste(src: String) {
        let dst = self.convert(src: src)
        setPasteboardString(dst: dst)
        pollingCopyCompleted(src: src) { dst in
            self.cmdKeyEvent(virtualKey: Sauce.shared.keyCode(for: .v), flags: .maskCommand)
            self.cmdKeyEvent(virtualKey: Sauce.shared.keyCode(for: .rightArrow))
        }
    }
    func copyConvertPaste() {
        let pre = getPasteboardString()
        copyCurrentLine()
        pollingCopyCompleted(src: pre, completion: convertPaste)
    }
}
