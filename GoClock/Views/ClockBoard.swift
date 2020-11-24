//
//  ClockBoard.swift
//  GoClock
//
//  Created by Zheng Kanyan on 2020/9/25.
//  Copyright © 2020 Zheng Kanyan. All rights reserved.
//

import SwiftUI

struct ClockBoard: View {
    @EnvironmentObject var store: Store
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    
    var clockState: AppState.ClockState {
        store.appState.clockState
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ClockSide(side: .hostSide).rotationEffect(Angle.degrees(180))
                ClockSide(side: .guestSide)
            }

            if clockState.playState == .running {
                Button(action: {
                    self.store.dispatch(.pause)
                }) {
                    Image(systemName: "pause")
                        .resizable().scaledToFit()
                }
                .modifier(ButtonModier())
                .offset(y: clockState.turn == .hostSide ? lessScreenHeight : -lessScreenHeight)
            } else {
                Button(action: {
                    self.viewControllerHolder?
                        .present(style: .fullScreen)  {
                            Settings().environmentObject(store)
                        }
                }) {
                    Image("setting")
                        .resizable().scaledToFit()
                }
                .modifier(ButtonModier())
                .offset(x: clockState.playState == .ready ? 0 : 100,
                        y: clockState.turn == .hostSide ? lessScreenHeight : -lessScreenHeight)
                if clockState.playState != .ready {
                    Button(action: {
                        self.store.dispatch(.reset)
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .resizable().scaledToFit()
                    }
                    .modifier(ButtonModier())
                    .offset(x: -100,
                            y: clockState.turn == .hostSide ? lessScreenHeight : -lessScreenHeight)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .statusBar(hidden: true)
        .onAppear(perform: {
            print("\(UIDevice.modelName), Width: \(screenWidth), Height: \(screenHeight)")
        })
    }
}

struct ButtonModier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .frame(width: 45, height: 45)
            .padding(10)
            .background(Circle().fill(Color.gray))
    }
}

struct ClockBoard_Previews: PreviewProvider {
    static var previews: some View {
        ClockBoard().environmentObject(Store())
    }
}
