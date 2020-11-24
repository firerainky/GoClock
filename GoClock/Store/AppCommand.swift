//
//  AppCommand.swift
//  GoClock
//
//  Created by Zheng Kanyan on 2020/9/25.
//  Copyright © 2020 Zheng Kanyan. All rights reserved.
//

import Foundation
import Combine
import AVFoundation

protocol AppCommand {
    func execute(in store: Store)
}

struct PlaySoundCommand: AppCommand {
    let seconds: Int?
    static let Voice = AVSpeechSynthesisVoice(language: "zh-CN")
    static let Synthesizer = AVSpeechSynthesizer()
    
    func execute(in store: Store) {
        if seconds == nil {
            AudioServicesPlayAlertSound(1052)
        } else if let warnings = store.appState.settings.lowTimeWarnings[seconds!] {
            for _ in warnings {
                let string = "\(seconds!)秒"
                let utterance = AVSpeechUtterance(string: string)
                utterance.voice = PlaySoundCommand.Voice
                utterance.rate = AVSpeechUtteranceDefaultSpeechRate
                PlaySoundCommand.Synthesizer.speak(utterance)
            }
        }
    }
}

struct StartTimerCommand: AppCommand {
    
    func execute(in store: Store) {
        store.timer = Timer.scheduledTimer(withTimeInterval: Interval, repeats: true) { _ in
            store.dispatch(.timeMinus(Interval))
        }
    }
}

struct StopTimerCommand: AppCommand {
    func execute(in store: Store) {
        if let timer = store.timer {
            timer.invalidate()
        }
    }
}

class SubscriptionToken {
    var cancellable: AnyCancellable?
    func unseal() {
        cancellable = nil
    }
}

extension AnyCancellable {
    func seal(in token: SubscriptionToken) {
        token.cancellable = self
    }
}
