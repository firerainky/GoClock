//
//  AppState.swift
//  GoClock
//
//  Created by Zheng Kanyan on 2020/9/25.
//  Copyright © 2020 Zheng Kanyan. All rights reserved.
//

import Foundation
import Combine

// 计时规则
struct Byoyomi: Codable {
    var name: String
    var mainTime: Int
    var periodTime: Int
    var periodNumber: Int
    var periodMoves = 1
    
    static var defaultByoyomi: Byoyomi {
        Byoyomi(name: "10分，30秒，3次", mainTime: 600, periodTime: 30, periodNumber: 3)
    }
    
    static func ==(lhs: Byoyomi, rhs: Byoyomi) -> Bool {
        lhs.mainTime == rhs.mainTime
            && lhs.periodTime == rhs.periodTime
            && lhs.periodNumber == rhs.periodNumber
    }
}

struct AppState: CustomStringConvertible {
    var description: String {
        
        var result = "clockState: [ \n"
            + "    byoyomi(\(clockState.byoyomi.name), \(clockState.byoyomi.mainTime), \(clockState.byoyomi.periodTime)-\(clockState.byoyomi.periodNumber))\n"
            + "    timeControllers:"
            + "(\(clockState.timeControllers[0].remainingTime)-\(clockState.timeControllers[0].remainingPeriodNumber)), "
            + "(\(clockState.timeControllers[1].remainingTime)-\(clockState.timeControllers[1].remainingPeriodNumber))\n"
            + "    turn: \(clockState.turn.rawValue == 0 ? "host" : "guest"))\n"
            + "    playState: \(clockState.playState)\n]\n"
            + "settings: [ \n"
            + "    timeControls: [ \n"
            + "        byoyomis: [ \n"
        
        for byoyomi in settings.timeControls.byoyomis {
            result += "            (\(byoyomi.name), \(byoyomi.mainTime), \(byoyomi.periodTime)-\(byoyomi.periodNumber))\n"
        }
        result += "        ]\n"
        result += "        currentIndex: \(settings.timeControls.currentIndex)"
        result += "    ]\n]"
        
        return result
    }
    
    var usingCurrentByoyomi: Bool {
        return clockState.byoyomi == settings.timeControls.currentByoyomi
    }
    
    init() {
        clockState = ClockState(
            byoyomi: settings.timeControls.byoyomis[
                settings.timeControls.currentIndex
            ]
        )
    }
    
    // 棋钟的状态
    struct ClockState {
        
        var byoyomi: Byoyomi
        
        class TimeController {
            @Published var remainingTime: TimeInterval
            @Published var remainingPeriodNumber: Int
            
            init(remainingTime: TimeInterval, remainingPeriodNumber: Int) {
                self.remainingTime = remainingTime
                self.remainingPeriodNumber = remainingPeriodNumber
            }
        }
        
        var timeControllers: [TimeController]
        
        enum SideType: Int {
            case hostSide = 0
            case guestSide = 1
        }
        var turn = SideType.guestSide
        var turnNumber = 0
        
        enum PlayState: Int, Codable, CustomStringConvertible {
            case paused
            case end
            case running
            case ready
            
            var description: String {
                switch self {
                case .paused:
                    return "paused"
                case .end:
                    return "end"
                case .running:
                    return "running"
                case .ready:
                    return "ready"
                }
            }
        }
        
        var playState = PlayState.ready
        
        init(byoyomi: Byoyomi) {
            self.byoyomi = byoyomi
            timeControllers = [
                TimeController(
                    remainingTime: TimeInterval(byoyomi.mainTime),
                    remainingPeriodNumber: byoyomi.periodNumber
                ),
                TimeController(
                    remainingTime: TimeInterval(byoyomi.mainTime),
                    remainingPeriodNumber: byoyomi.periodNumber
                )
            ]
        }
    }
    
    var clockState: ClockState
    
    // 设置的状态
    struct Settings {
        
        struct TimeControls {
            @UserDefaultsStorage("byoyomis", defaultValue: [
                Byoyomi(name: "10分，30秒，3次",
                        mainTime: 600,
                        periodTime: 30,
                        periodNumber: 3),
                Byoyomi(name: "30分，1分，5次",
                        mainTime: 1800,
                        periodTime: 60,
                        periodNumber: 5)
            ])
            var byoyomis: [Byoyomi]
            
            @UserDefaultsStorage("currentIndex",
                                 defaultValue: 0)
            var currentIndex: Int
            
            var currentByoyomi: Byoyomi {
                byoyomis[currentIndex]
            }
        }
        
        var timeControls: TimeControls = TimeControls()
        
        enum WarningType: String, Codable {
            case speech = "语音"
            case screenFlash = "闪动"
            case beep = "嘟嘟"
            case alerm = "警告"
        }

        @UserDefaultsStorage("lowTimeWarnings",
                             defaultValue: [
                                0:[.beep],
                                5:[.speech],
                                10:[.screenFlash]
                             ])
        var lowTimeWarnings: [Int:Set<WarningType>]
        
        @UserDefaultsStorage("enableClickSound", defaultValue: true)
        var enableClickSound: Bool
//        struct ClickSound {
//            var enable = true
//            
//            enum ClickSoundType {
//                case click
//                case chirk
//            }
//            var clickSoundType = ClickSoundType.click
//        }
//        
//        @UserDefaultsStorage("clickSound", defaultValue: ClickSound())
//        var clickSound: ClickSound
        
        @UserDefaultsStorage("airplaneModeReminder", defaultValue: true)
        var airplaneModeReminder
        @UserDefaultsStorage("alwaysShowTurnNumber", defaultValue: false)
        var alwaysShowTurnNumber
    }
    
    var settings = Settings()
}
