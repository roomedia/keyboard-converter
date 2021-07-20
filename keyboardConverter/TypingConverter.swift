//
//  TypingConverter.swift
//  keyboardConverter
//
//  Created by 김동호 on 2021/07/20.
//

import Foundation

class TypingConverter {
    static let KOREAN2SET = [
        "ㅂ", "ㅃ", "ㅈ", "ㅉ", "ㄷ", "ㄸ", "ㄱ", "ㄲ", "ㅅ", "ㅆ", "ㅛ", "ㅕ", "ㅑ", "ㅐ", "ㅒ", "ㅔ", "ㅖ", "ㅁ", "ㄴ", "ㅇ", "ㄹ", "ㅎ", "ㅗ", "ㅓ", "ㅏ", "ㅣ", "ㅋ", "ㅌ", "ㅊ", "ㅍ", "ㅠ", "ㅜ", "ㅡ"
    ]
    
    static let QWERTY = [
        "q", "Q", "w", "W", "e", "E", "r", "R", "t", "T", "y", "u", "i", "o", "O", "p", "P", "a", "s", "d", "f", "g", "h", "j", "k", "l", "z", "x", "c", "v", "b", "n", "m"
    ]
    
    class func convert(_ text: String) -> String {
        if CharacterSet.isHangul(text: text) {
            return convert(Jamo.disassemble(text), src: KOREAN2SET, dst: QWERTY).joined()
        } else {
            return Jamo.assemble(convert(text, src: QWERTY, dst: KOREAN2SET))
        }
    }
    
    class func convert(_ text: String, src: [String], dst: [String]) -> [String] {
        return text.map { char -> String in
            if let index = src.firstIndex(of: String(char)) {
                return dst[index]
            } else {
                return String(char)
            }
        }
    }
}
