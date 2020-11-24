//
//  Reducer.swift
//  GoClock
//
//  Created by Zheng Kanyan on 2020/9/24.
//  Copyright © 2020 Zheng Kanyan. All rights reserved.
//

import Foundation

enum AppAction {
    case clickClock
    case pause
    case gotoSettings
    case reset
//    case resume
    case timeMinus(_ interval: TimeInterval)
    case playSound(at: Int)
    case updateByoyomi(in: Int?, with: Byoyomi)
    case selectCurrentByoyomi(index: Int)
    case deleteByoyomi(index: Int)
    case updateSettings(enableClickSound: Bool, alwaysShowTurnNumber: Bool, airplaneModeReminder: Bool)
//    case confirmSettings
}
