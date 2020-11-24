//
//  ClockSide.swift
//  GoClock
//
//  Created by Zheng Kanyan on 2020/9/25.
//  Copyright © 2020 Zheng Kanyan. All rights reserved.
//

import SwiftUI
import UIKit

let Width = UIScreen.main.bounds.size.width
let LessHeight = UIScreen.main.bounds.size.height * 1/4
let MoreHeight = UIScreen.main.bounds.size.height * 3/4

extension VerticalAlignment {
    enum MiddleAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[VerticalAlignment.center]
        }
    }
    
    static let middleAlignment = VerticalAlignment(MiddleAlignment.self)
}

extension HorizontalAlignment {
    enum MiddleAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[HorizontalAlignment.center]
        }
    }
    
    static let middleAlignment = HorizontalAlignment(MiddleAlignment.self)
}

struct ClockSide: View {
    @EnvironmentObject var store: Store
    private var clockState: AppState.ClockState {
        store.appState.clockState
    }
    private var settings: AppState.Settings {
        store.appState.settings
    }
    let side: AppState.ClockState.SideType
    
    var body: some View {
        
        GeometryReader { proxy in
            ZStack(
                alignment: Alignment(
                    horizontal: HorizontalAlignment.middleAlignment,
                    vertical: VerticalAlignment.middleAlignment)
            ) {
                Rectangle().fill(Color.clear)
                VStack {
                    Text(timeStamp(from: clockState.timeControllers[side.rawValue].remainingTime))
                        .font(.largeTitle)
                        .alignmentGuide(VerticalAlignment.middleAlignment) {
                            $0[VerticalAlignment.center]
                        }
                    if side == clockState.turn {
                        if clockState.playState == .ready {
                            Text("TAP TO START")
                        } else if clockState.playState == .paused {
                            Text("TAP TO RESUME")
                        } else if clockState.playState == .end {
                            Text("OUT OF TIME")
                        }
                    }
                }
                Text("\(timeStamp(from: clockState.byoyomi.periodTime)), \(clockState.timeControllers[side.rawValue].remainingPeriodNumber) times")
                    .padding(.bottom, UIDevice.current.hasNotch ? 34 : 10)
                    .alignmentGuide(VerticalAlignment.middleAlignment) {
                        $0[VerticalAlignment.bottom] - proxy.size.height / 2
                    }
                    .alignmentGuide(HorizontalAlignment.middleAlignment) {
                        $0[HorizontalAlignment.leading] + proxy.size.width / 2 - 15
                    }
//                if settings.airplaneModeReminder && store.netStatus.connected {
//                    Image(systemName: "airplane")
//                        .padding(.bottom, UIDevice.current.hasNotch ? 34 : 10)
//                        .alignmentGuide(VerticalAlignment.middleAlignment) {
//                            $0[VerticalAlignment.bottom] - proxy.size.height / 2
//                        }
//                }
                if settings.alwaysShowTurnNumber && clockState.turnNumber > 0 && side == clockState.turn {
                    Text("Turn \(clockState.turnNumber)")
                        .padding(.bottom, UIDevice.current.hasNotch ? 34 : 10)
                        .alignmentGuide(VerticalAlignment.middleAlignment) {
                            $0[VerticalAlignment.bottom] - proxy.size.height / 2
                        }
                        .alignmentGuide(HorizontalAlignment.middleAlignment) {
                            $0[HorizontalAlignment.trailing] - proxy.size.width / 2 + 15
                        }
                }
            }
        }
        .frame(width: Width,
               height: side == clockState.turn
                ? MoreHeight : LessHeight)
        .background(side == .hostSide ? Color.black : Color.white)
        .foregroundColor(side == .hostSide ? Color.white : Color.black)
        .onTapGesture {
            if (self.side == clockState.turn
                    && clockState.playState != .end) {
                self.store.dispatch(.clickClock)
            }
        }
    }
}

struct ClockSide_Previews: PreviewProvider {
    static var previews: some View {
        ClockBoard().environmentObject(Store()).previewDevice(PreviewDevice(rawValue: "iPhone SE"))
            .previewDisplayName("iPhone SE")
        ClockBoard().environmentObject(Store()).previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
            .previewDisplayName("iPhone Pro")
    }
}
