//
//  Reader.swift
//  MyReader
//
//  Created by Myron on 2018/1/18.
//  Copyright © 2018年 myron. All rights reserved.
//

import UIKit
import AVFoundation

class Reader: NSObject, AVSpeechSynthesizerDelegate {
    
    // MARK: - Init
    
    /** Reader Player */
    private let player = AVSpeechSynthesizer()
    /** Current Utterance */
    private var current: AVSpeechUtterance?
    
    override init() {
        super.init()
        player.delegate = self
    }
    
    
    // MARK: - Texts
    
    /** text view */
    weak var view: UITextView?
    
    /** texts */
    var texts: [String] = []
    /** texts's start index */
    var start: String.Index!
    /** texts's end index */
    var ended: String.Index!
    
    // MARK: Text action
    
    /** reset the visible texts */
    func text_reset() {
        texts.removeAll(keepingCapacity: true)
        guard let book = view?.text else { return }
        guard let range = view?.visible_range() else { return }
        
        ended = book.endIndex
        start = range.lowerBound
        for (index, char) in String(book[start ..< ended]).enumerated() {
            if ["。", "？", "！", "：", "；", "\n"].contains(char) {
                ended = book.index(book.startIndex, offsetBy: index + 1 + book.distance(from: book.startIndex, to: start))
                var text = String(book[start ..< ended])
                while text.first == "\n" {
                    text.removeFirst()
                }
                if !text.isEmpty {
                    texts.append(text)
                    if texts.count >= 10 { break }
                }
                start = ended
            }
        }
        start = range.lowerBound
    }
    
    /** text */
    func text_update() {
        if texts.count >= 10 { return }
        guard let book = view?.text else { return }
        guard var start = self.ended else { return }
        
        for (index, char) in String(book[start ..< book.endIndex]).enumerated() {
            if ["。", "？", "！", "：", "；", "\n"].contains(char) {
                ended = book.index(book.startIndex, offsetBy: index + 1 + book.distance(from: book.startIndex, to: start))
                var text = String(book[start ..< ended])
                while text.first == "\n" {
                    text.removeFirst()
                }
                if !text.isEmpty {
                    texts.append(text)
                    if texts.count >= 10 { break }
                }
                start = ended
            }
        }
    }
    
    // MARK: - Property
    
    /** 播放语言的速率，值越大，播放速率越快 */
    var rate: Float = 0.4
    /** 音调  --  为语句指定pitchMultiplier ，可以在播放特定语句时改变声音的音调、pitchMultiplier的允许值一般介于0.5(低音调)和2.0(高音调)之间 */
    var pitchMultiplier: Float = 1
    // 让语音合成器在播放下一句之前有短暂时间的暂停，也可以类似的设置preUtteranceDelay
    var postUtteranceDelay: TimeInterval = 0.1
    
    // MARK: - Play Control
    
    /** 播放 */
    func play() {
        if !player.isSpeaking {
            if player.isPaused {
                player.continueSpeaking()
            } else if !texts.isEmpty {
                play_deploy(text: texts.removeFirst())
            }
        }
    }
    
    private func play_deploy(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = rate
        utterance.pitchMultiplier = pitchMultiplier
        utterance.postUtteranceDelay = postUtteranceDelay
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        current = utterance
        player.speak(utterance)
    }
    
    /** 暂停 */
    func pause() {
        player.pauseSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    /** 停止 */
    func stop() {
        player.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    // MARK: - Delegate
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("speechSynthesizer didStart \(utterance.speechString)")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("speechSynthesizer didFinish \(utterance.speechString)")
        if texts.count < 4 {
            text_update()
        }
        if texts.count > 0 {
            play_deploy(text: texts.removeFirst())
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        print("speechSynthesizer didPause \(utterance.speechString)")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        print("speechSynthesizer didContinue \(utterance.speechString)")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        print("speechSynthesizer didCancel \(utterance.speechString)")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        print("speechSynthesizer willSpeakRangeOfSpeechString \(characterRange.lowerBound) - \(characterRange.upperBound) \(utterance.speechString)")
    }
}
