//
//  Reader.swift
//  MyReader
//
//  Created by Myron on 2018/1/18.
//  Copyright © 2018年 myron. All rights reserved.
//

import Foundation
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
    
    
    // MARK: - Values
    
    /** texts */
    var texts: [String] = []
    /** Texts Range */
    var text_start: String.Index?
    var text_ended: String.Index?
    
    func reset_texts(_ value: String, start: String.Index) {
        texts.removeAll()
        text_start = start
        var text = value
        text.removeSubrange(text.startIndex ..< start)
        while texts.count < 10 {
            if let index = Book.segment(text: text) {
                texts.append(String(text[text.startIndex ..< index]))
                text_ended = index
                text.removeSubrange(text.startIndex ..< index)
            } else {
                break
            }
        }
    }
    
    func append_texts(_ value: String) {
        
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
