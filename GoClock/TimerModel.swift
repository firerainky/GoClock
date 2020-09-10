//
//  TimerModel.swift
//  GoClock
//
//  Created by Zheng Kanyan on 2020/9/7.
//  Copyright © 2020 Zheng Kanyan. All rights reserved.
//

import Foundation
import AVFoundation
import SwiftySound

/* 这个棋钟的状态：
 暂停态（点击后继续计时且不切换计时）；
 结束态（有一方超时结束，点击无响应）
 运行态（点击后继续计时且切换计时）
 */
enum TimerModelState {
    case stop
    case end
    case run
    case ready
}

/*
 每方的显示状态
 */
enum TimeState {
    case starting
    case running
    case outOfTime
    case resumming
}

/*
 时间规则
 */
struct TimerRule {
    var freeTime: TimeInterval
    var countDownTime: TimeInterval
    var countDownNum: Int
}

class TimerModel: ObservableObject {
//    static let `default` = TimerBrain(freeTime: freeTime, countTime: totalCountDownTime, reservationNum: 3)
    
    // 双方的时间显示状态
    @Published private(set) var hostState: TimeState = .running
    @Published private(set) var guestState: TimeState = .starting
    
    // 双方的时间
    @Published private(set) var hostTime: TimeInterval
    @Published private(set) var guestTime: TimeInterval
    
    // true: 主方（黑棋）回合，false: 客方（白棋）回合
    @Published private(set) var hostTurn = false
    
    // 整个棋钟的状态
    @Published private(set) var modelState = TimerModelState.ready
    
    // 双方的读秒显示状态
    @Published var hostPhase: (TimeInterval, Int)? = nil
    @Published var guestPhase: (TimeInterval, Int)? = nil
    
    // 双方各自的计时器
    private var hostTimer: Timer? = nil
    private var guestTimer: Timer? = nil
    
    // 两方各自走的步数
//    @State var hostMove: Int = 0
//    @State var guestMove: Int = 0
    
    // 读秒规则（读秒时间，保留次数）
    private var timerRule: TimerRule
    
    init() {
        self.timerRule = TimerRule(freeTime: 5, countDownTime: 5, countDownNum: 2)
        self.hostState = .running
        self.guestState = .starting
        self.hostTime = timerRule.freeTime
        self.guestTime = timerRule.freeTime
        self.hostPhase = (timerRule.countDownTime, timerRule.countDownNum)
        self.guestPhase = (timerRule.countDownTime, timerRule.countDownNum)
    }
    
    func tap(onHost: Bool) {
        if onHost == hostTurn && modelState != .end {
            AudioServicesPlayAlertSound(1052)
            // 正确点击且未结束
            if modelState != .stop {
                // 交换计时
                hostTurn.toggle()
            }
            if (onHost && modelState == .stop) || (!onHost && modelState != .stop) {
                weak var weakSelf = self
                if guestPhase != nil && guestPhase!.1 < timerRule.countDownNum {
                    guestTime = timerRule.countDownTime
                }
                hostTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {_ in
                    weakSelf?.hostTime -= 0.1
                    if let leftTime = weakSelf?.hostTime, leftTime <= 0 {
                        weakSelf?.countToZero(hostSide: true)
                    } else if let leftTime = weakSelf?.hostTime, abs(leftTime - 10.4) <= 0.01 {
                        Sound.play(file: "ten.mp3")
                    } else if let leftTime = weakSelf?.hostTime, abs(leftTime - 9.4) <= 0.01 {
                       Sound.play(file: "nine.mp3")
                    } else if let leftTime = weakSelf?.hostTime, abs(leftTime - 8.4) <= 0.01 {
                       Sound.play(file: "eight.mp3")
                    } else if let leftTime = weakSelf?.hostTime, abs(leftTime - 7.4) <= 0.01 {
                       Sound.play(file: "seven.mp3")
                    } else if let leftTime = weakSelf?.hostTime, abs(leftTime - 6.4) <= 0.01 {
                      Sound.play(file: "six.mp3")
                    } else if let leftTime = weakSelf?.hostTime, abs(leftTime - 5.4) <= 0.01 {
                      Sound.play(file: "five.mp3")
                    } else if let leftTime = weakSelf?.hostTime, abs(leftTime - 4.4) <= 0.01 {
                      Sound.play(file: "four.mp3")
                    } else if let leftTime = weakSelf?.hostTime, abs(leftTime - 3.4) <= 0.01 {
                      Sound.play(file: "three.mp3")
                    } else if let leftTime = weakSelf?.hostTime, abs(leftTime - 2.4) <= 0.01 {
                      Sound.play(file: "two.mp3")
                    } else if let leftTime = weakSelf?.hostTime, abs(leftTime - 1.4) <= 0.01 {
                      Sound.play(file: "one.mp3")
                    }
                })
                guestTimer?.invalidate()
            } else {
                weak var weakSelf = self
                if hostPhase != nil && hostPhase!.1 < timerRule.countDownNum {
                    hostTime = timerRule.countDownTime
                }
                guestTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {_ in
                    weakSelf?.guestTime -= 0.1
                    if let leftTime = weakSelf?.guestTime, leftTime <= 0 {
                        weakSelf?.countToZero(hostSide: false)
                    } else if let leftTime = weakSelf?.guestTime, abs(leftTime - 10.4) <= 0.01 {
                        Sound.play(file: "ten.mp3")
                    } else if let leftTime = weakSelf?.guestTime, abs(leftTime - 9.4) <= 0.01 {
                        Sound.play(file: "nine.mp3")
                    } else if let leftTime = weakSelf?.guestTime, abs(leftTime - 8.4) <= 0.01 {
                        Sound.play(file: "eight.mp3")
                    } else if let leftTime = weakSelf?.guestTime, abs(leftTime - 7.4) <= 0.01 {
                        Sound.play(file: "seven.mp3")
                    } else if let leftTime = weakSelf?.guestTime, abs(leftTime - 6.4) <= 0.01 {
                       Sound.play(file: "six.mp3")
                    } else if let leftTime = weakSelf?.guestTime, abs(leftTime - 5.4) <= 0.01 {
                       Sound.play(file: "five.mp3")
                    } else if let leftTime = weakSelf?.guestTime, abs(leftTime - 4.4) <= 0.01 {
                       Sound.play(file: "four.mp3")
                    } else if let leftTime = weakSelf?.guestTime, abs(leftTime - 3.4) <= 0.01 {
                       Sound.play(file: "three.mp3")
                    } else if let leftTime = weakSelf?.guestTime, abs(leftTime - 2.4) <= 0.01 {
                       Sound.play(file: "two.mp3")
                    } else if let leftTime = weakSelf?.guestTime, abs(leftTime - 1.4) <= 0.01 {
                       Sound.play(file: "one.mp3")
                    }
                })
                hostTimer?.invalidate()
            }
            modelState = .run
            hostState = .running
            guestState = .running
        }
    }
    
    func pause() {
        // 暂停计时
        hostTimer?.invalidate()
        guestTimer?.invalidate()
        if hostTurn {
            hostState = .resumming
        } else {
            guestState = .resumming
        }
        modelState = .stop
    }
    
    func reset() {
        // 点击重新开始
        modelState = .ready
        hostState = .running
        guestState = .starting
        hostTime = timerRule.freeTime
        guestTime = timerRule.freeTime
        hostTurn = false
        hostPhase = (timerRule.countDownTime, timerRule.countDownNum)
        guestPhase = (timerRule.countDownTime, timerRule.countDownNum)
    }
    
    private func countToZero(hostSide: Bool) {
        if hostSide {
            if hostPhase == nil || hostPhase!.1 <= 1 {
                runOutOfTime(hostSide: hostSide)
            } else {
                hostPhase!.1 -= 1
                if hostPhase!.1 == timerRule.countDownNum - 1 {
//                    Sound.play(file: "start-countdown.mp3")
                }
                switch hostPhase!.1 {
                case 1:
                    Sound.play(file: "countdown-remain-1.mp3")
                case 2:
                    Sound.play(file: "countdown-remain-2.mp3")
                case 3:
                    Sound.play(file: "countdown-remain-3.mp3")
                case 4:
                    Sound.play(file: "countdown-remain-4.mp3")
                case 5:
                    Sound.play(file: "countdown-remain-5.mp3")
                default:
                    print("something wrong")
                }
                hostTime = timerRule.countDownTime
            }
        } else {
            if guestPhase == nil || guestPhase!.1 <= 1 {
                runOutOfTime(hostSide: hostSide)
            } else {
                guestPhase!.1 -= 1
                if guestPhase!.1 == timerRule.countDownNum - 1 {
//                    Sound.play(file: "start-countdown.mp3")
                }
                switch guestPhase!.1 {
                case 1:
                    Sound.play(file: "countdown-remain-1.mp3")
                case 2:
                    Sound.play(file: "countdown-remain-2.mp3")
                case 3:
                    Sound.play(file: "countdown-remain-3.mp3")
                case 4:
                    Sound.play(file: "countdown-remain-4.mp3")
                case 5:
                    Sound.play(file: "countdown-remain-5.mp3")
                default:
                    print("something wrong")
                }
                guestTime = timerRule.countDownTime
            }
        }
    }
    
    private func runOutOfTime(hostSide: Bool) {
        modelState = .end
        AudioServicesPlayAlertSound(1014)
        if hostSide {
            hostState = .outOfTime
        } else {
            guestState = .outOfTime
        }
        hostTimer?.invalidate()
        guestTimer?.invalidate()
    }
}
