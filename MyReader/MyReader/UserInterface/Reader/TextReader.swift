//
//  TextReader.swift
//  MyReader
//
//  Created by 黄穆斌 on 2018/1/16.
//  Copyright © 2018年 myron. All rights reserved.
//

import AVFoundation

class TextReader {
    
    var utterance = AVSpeechUtterance(string: "")
    var synthesizer = AVSpeechSynthesizer()
    
    func load(text: String) {
        utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        //播放语言的速率，值越大，播放速率越快
        utterance.rate = 0.4
        //音调  --  为语句指定pitchMultiplier ，可以在播放特定语句时改变声音的音调、pitchMultiplier的允许值一般介于0.5(低音调)和2.0(高音调)之间
        utterance.pitchMultiplier = 1
        //让语音合成器在播放下一句之前有短暂时间的暂停，也可以类似的设置preUtteranceDelay
        utterance.postUtteranceDelay = 0.1
        synthesizer.speak(utterance)
    }

}
