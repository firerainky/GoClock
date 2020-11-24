//
//  Store.swift
//  GoClock
//
//  Created by Zheng Kanyan on 2020/9/24.
//  Copyright © 2020 Zheng Kanyan. All rights reserved.
//

import Foundation
import Combine
//import SwiftySound
import AVFoundation
import Network

let Interval = 0.01

class Store: ObservableObject {
    
//    class NetStatus: ObservableObject {
//
//        let monitor = NWPathMonitor()
//        let queue = DispatchQueue.global(qos: .background)
//
//        @Published var connected: Bool = false
//        private var isConnected: Bool = false
//
//        init() {
//            monitor.start(queue: queue)
//
//            monitor.pathUpdateHandler = { path in
//                if path.status == .satisfied {
//                    OperationQueue.main.addOperation {
//                        self.isConnected = true
//                        self.connected = self.isConnected
//                    }
//                } else {
//                    OperationQueue.main.addOperation {
//                        self.isConnected = false
//                        self.connected = self.isConnected
//                    }
//                }
//            }
//        }
//    }
//    
//    @Published var netStatus = NetStatus()
    
    @Published var appState = AppState()
    var timer: Timer?
    
    init() {
        self.setupObservers()
    }
    
    var disposeBag = [AnyCancellable]()
    
    func setupObservers() {
//        Timer.publish(every: Interval, on: RunLoop.current, in: .common)
//            .autoconnect().sink { _ in
//                self.dispatch(.timeMinus(Interval))
//            }
//            .store(in: &disposeBag)

        for timeController in appState.clockState.timeControllers {
            timeController.$remainingTime.sink { value in
                let intValue = Int(value)
                if value >= 0 && value - Double(intValue) <= Interval {
                    self.dispatch(.playSound(at: intValue))
                }
            }
            .store(in: &disposeBag)
        }
    }
    
    func dispatch(_ action: AppAction) -> Void {
        #if DEBUG
//        print("[ACTION]: \(action)")
        #endif
        let result = Store.reduce(state: appState, action: action)
        appState = result.0
        
        for command in result.1 {
            #if DEBUG
//            print("[COMMAND]: \(command)")
            #endif
            command.execute(in: self)
        }
    }
    
    static func reduce(state: AppState, action: AppAction) -> (AppState, [AppCommand]) {
        var appState = state
        var appCommands = [AppCommand]()
        
        switch action {
        case .clickClock:
            if appState.clockState.playState != .running {
                appCommands.append(StartTimerCommand())
                appState.clockState.playState = .running
            }
            appState.clockState.turn =
                appState.clockState.turn == .hostSide ? .guestSide : .hostSide
            appState.clockState.turnNumber += 1
            if appState.settings.enableClickSound {
                appCommands.append(PlaySoundCommand(seconds: nil))
            }
        case .timeMinus(let interval):
            if appState.clockState.playState == .running {
                let index = appState.clockState.turn.rawValue
                appState.clockState.timeControllers[index].remainingTime -= interval
                if appState.clockState.timeControllers[index].remainingTime <= 0 {
                    appState.clockState.timeControllers[index].remainingPeriodNumber -= 1
                    if appState.clockState.timeControllers[index].remainingPeriodNumber <= 0 {
                        appState.clockState.playState = .end
                    } else {
                        appState.clockState.timeControllers[index].remainingTime
                            = TimeInterval(appState.clockState.byoyomi.periodTime)
                    }
                }
            }
        case .playSound(let seconds):
            if appState.clockState.playState == .running {
                appCommands.append(PlaySoundCommand(seconds: seconds))
            }
        case .pause:
            appCommands.append(StopTimerCommand())
            appState.clockState.playState = .paused
        case .reset:
            appState.clockState.playState = .ready
            appState.clockState.turn = .guestSide
            appState.clockState.turnNumber = 0
            appState.clockState.byoyomi =
                appState.settings.timeControls.currentByoyomi
            appState.clockState.timeControllers = [
                AppState.ClockState.TimeController(
                    remainingTime: TimeInterval(appState.clockState.byoyomi.mainTime),
                    remainingPeriodNumber: appState.clockState.byoyomi.periodNumber),
                AppState.ClockState.TimeController(
                    remainingTime: TimeInterval(appState.clockState.byoyomi.mainTime),
                    remainingPeriodNumber: appState.clockState.byoyomi.periodNumber)
            ]
            appCommands.append(StopTimerCommand())
//        case .resume:
//            appState.clockState.playState = .running
        case .gotoSettings:
            print("do nothing")
//            appState.clockState.playState = .paused
        case .updateByoyomi(let index, let byoyomi):
            if index == nil {
                appState.settings.timeControls.byoyomis.append(byoyomi)
            } else {
                appState.settings.timeControls.byoyomis[index!] = byoyomi
            }
        case .selectCurrentByoyomi(let index):
            appState.settings.timeControls.currentIndex = index
        case .deleteByoyomi(let index):
            if index == appState.settings.timeControls.currentIndex {
                appState.settings.timeControls.currentIndex = 0
            }
            appState.settings.timeControls.byoyomis.remove(at: index)
            if appState.settings.timeControls.byoyomis.count <= 0 {
                appState.settings.timeControls.byoyomis.append(Byoyomi.defaultByoyomi)
            }
        case .updateSettings(let enableClickSound, let alwaysShowTurnNumber, let airplaneModeReminder):
            appState.settings.enableClickSound = enableClickSound
            appState.settings.alwaysShowTurnNumber = alwaysShowTurnNumber
            appState.settings.airplaneModeReminder = airplaneModeReminder
        }

        return (appState, appCommands)
    }
}
