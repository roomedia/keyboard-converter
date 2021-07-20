//
//  Jamo.swift
//
//  Created by hyunsoo go on 2015. 10. 13..
//  Copyright © 2015년 YUNKO STUDIO. All rights reserved.
//

import Foundation

extension CharacterSet{
    static var modernHangul: CharacterSet {
        return CharacterSet(charactersIn: ("가".unicodeScalars.first!)...("힣".unicodeScalars.first!))
    }
    
    static var jaeum: CharacterSet {
        return CharacterSet(charactersIn: ("ㄱ".unicodeScalars.first!)...("ㅎ".unicodeScalars.first!))
    }
    
    static var moeum: CharacterSet {
        return CharacterSet(charactersIn: ("ㅏ".unicodeScalars.first!)...("ㅣ".unicodeScalars.first!))
    }
    
    static var korean: CharacterSet {
        return jaeum.union(moeum).union(modernHangul)
    }
    
    static func isHangul(text: String) -> Bool {
        return nil != text.unicodeScalars.firstIndex {
            CharacterSet.korean.contains($0)
        }
    }
}

public class Jamo {
    
    // UTF-8 기준
    static let INDEX_HANGUL_START: UInt32 = 44032  // "가"
    static let INDEX_HANGUL_END: UInt32 = 55199    // "힣"
    
    static let INDEX_JAEUM_START: UInt32 = 12593  // "ㄱ"
    static let INDEX_MOEUM_START: UInt32 = 12623  // "ㅏ"
    
    static let CYCLE_CHO: UInt32 = 588
    static let CYCLE_JUNG: UInt32 = 28
    
    static let CHO = [
        "ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"
    ]
    
    static let JUNG = [
        "ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ","ㅕ", "ㅖ", "ㅗ", "ㅘ", "ㅙ", "ㅚ","ㅛ", "ㅜ", "ㅝ", "ㅞ", "ㅟ", "ㅠ", "ㅡ", "ㅢ", "ㅣ"
    ]
    
    static let JUNG_DOUBLE = [
        "ㅘ": "ㅗㅏ", "ㅙ": "ㅗㅐ", "ㅚ": "ㅗㅣ", "ㅝ": "ㅜㅓ", "ㅞ": "ㅜㅔ", "ㅟ": "ㅜㅣ", "ㅢ": "ㅡㅣ"
    ]
    
    static let JONG = [
        "", "ㄱ", "ㄲ", "ㄳ", "ㄴ", "ㄵ", "ㄶ", "ㄷ", "ㄹ", "ㄺ", "ㄻ", "ㄼ", "ㄽ", "ㄾ", "ㄿ", "ㅀ", "ㅁ", "ㅂ", "ㅄ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"
    ]
    
    static let JONG_DOUBLE = [
        "ㄳ": "ㄱㅅ", "ㄵ": "ㄴㅈ", "ㄶ": "ㄴㅎ", "ㄺ": "ㄹㄱ", "ㄻ": "ㄹㅁ", "ㄼ": "ㄹㅂ", "ㄽ": "ㄹㅅ", "ㄾ": "ㄹㅌ", "ㄿ": "ㄹㅍ", "ㅀ": "ㄹㅎ", "ㅄ": "ㅂㅅ"
    ]
    
    static let JAEUM = [
        "ㄱ", "ㄲ", "ㄳ", "ㄴ", "ㄵ", "ㄶ", "ㄷ", "ㄸ", "ㄹ", "ㄺ", "ㄻ","ㄼ","ㄽ","ㄾ","ㄿ","ㅀ", "ㅁ", "ㅂ", "ㅃ", "ㅄ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"
    ]
    
    // 주어진 "단어"를 자모음으로 분해해서 리턴하는 함수
    class func disassemble(_ input: String) -> String {
        var jamo = ""
        //let word = input.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .punctuationCharacters)
        for scalar in input.unicodeScalars {
            jamo += getJamoFromOneSyllable(scalar) ?? ""
        }
        return jamo
    }

    class func assemble(_ _inputlist: [String]) -> String {
        var result = ""
        var cho = 0
        var jung = 0
        var jong = 0
        
        var inputlist = _inputlist
        inputlist.insert("", at: 0)
        
        while inputlist.count > 1 {
            let c = inputlist.count
            if JONG.contains(inputlist[c-1]) {
                if JUNG.contains(inputlist[c-2]) {
                    jong = JONG.firstIndex(of: inputlist[c-1])!
                    inputlist.removeLast()
                }
                else {
                    result += inputlist[c-1]
                    inputlist.removeLast()
                }
            }
            else if JUNG.contains(inputlist[c-1]) {
                if CHO.contains(inputlist[c-2]) {
                    jung = JUNG.firstIndex(of: inputlist[c-1])!
                    cho = CHO.firstIndex(of: inputlist[c-2])!
                    inputlist.removeLast()
                    inputlist.removeLast()

                    result += String(UnicodeScalar(0xAC00 + 28 * (21 * cho + jung) + jong)!)
                    cho = 0
                    jung = 0
                    jong = 0
                }
                else {
                    result += inputlist[c-1]
                    inputlist.removeLast()
                }
            }
            else {
                result += inputlist[c-1]
                inputlist.removeLast()
            }
        }
        return String(result.reversed())
    }
    
    // 주어진 "코드의 음절"을 자모음으로 분해해서 리턴하는 함수
    private class func getJamoFromOneSyllable(_ n: UnicodeScalar) -> String? {
        if CharacterSet.modernHangul.contains(n) {
            let index = n.value - INDEX_HANGUL_START
            let cho = CHO[Int(index / CYCLE_CHO)]
            var jung = JUNG[Int((index % CYCLE_CHO) / CYCLE_JUNG)]
            if let disassembledJung = JUNG_DOUBLE[jung] {
                jung = disassembledJung
            }
            var jong = JONG[Int(index % CYCLE_JUNG)]
            if let disassembledJong = JONG_DOUBLE[jong] {
                jong = disassembledJong
            }
            return cho + jung + jong
        }
        else if CharacterSet.jaeum.contains(n) {
            let index = n.value - INDEX_JAEUM_START
            var jaeum = JAEUM[Int(index)]
            if let disassembledJaeum = JONG_DOUBLE[jaeum] {
                jaeum = disassembledJaeum
            }
            return jaeum
        }
        else if CharacterSet.moeum.contains(n) {
            let index = n.value - INDEX_MOEUM_START
            var moeum = JUNG[Int(index)]
            if let disassembledMoeum = JUNG_DOUBLE[moeum] {
                moeum = disassembledMoeum
            }
            return moeum
        }
        else {
            return String(UnicodeScalar(n))
        }
    }
}
