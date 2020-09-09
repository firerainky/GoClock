//
//  ContentView.swift
//  GoClock
//
//  Created by Zheng Kanyan on 2020/8/10.
//  Copyright © 2020 Zheng Kanyan. All rights reserved.
//

import SwiftUI
import AVFoundation

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let moreScreenHeight = screenHeight * 3 / 4
let lessScreenHeight = screenHeight * 1 / 4
//let freeTime: TimeInterval = 15
//let totalCountDownTime: TimeInterval = 15

struct ContentView: View {
    @EnvironmentObject var model: TimerModel
    @State var showResetAlert = false
    @State var isPresented = false
    
    var body: some View {
        ZStack {
            VStack {
                TurnTimerView(hostSide: true)
                TurnTimerView(hostSide: false)
            }
            if model.modelState == .ready {
                // 设置
                Button(action: {
//                    self.model.pause()
                    self.isPresented = true
                }) {
                    Image("setting").resizable().scaledToFit().foregroundColor(.white)
                }
                .frame(width: 60, height: 60).padding(5)
                .background(Circle().fill(Color.gray))
                .offset(y: model.hostTurn ? lessScreenHeight : -lessScreenHeight)
            } else if model.modelState == .run {
                // 暂停
                Button(action: {
                    self.model.pause()
                }) {
                    Image(systemName: "pause")
                        .resizable().scaledToFit().foregroundColor(.white)
                }
                .frame(width: 50, height: 50).padding(10)
                .background(Circle().fill(Color.gray))
                .offset(y: model.hostTurn ? lessScreenHeight : -lessScreenHeight)
            } else {
                // 重新开始
                Button(action: {
                    self.showResetAlert = true
                }) {
                    Image(systemName: "arrow.clockwise")
                        .resizable().scaledToFit().foregroundColor(.white)
                }
                .frame(width: 50, height: 50).padding(10)
                .background(Circle().fill(Color.gray))
                .offset(x: -100, y: model.hostTurn ? lessScreenHeight : -lessScreenHeight)
                .alert(isPresented: $showResetAlert) {
                    Alert(title: Text("是否重新计时"), primaryButton: .default(Text("是")) {
                        self.model.reset()
                        }, secondaryButton: .cancel(Text("否")))
                }
                
                // 设置
                Button(action: {
                //                    self.model.pause()
                    self.isPresented = true
                }) {
                    Image("setting").resizable().scaledToFit().foregroundColor(.white)
                }
                .frame(width: 60).padding(5)
                .background(Circle().fill(Color.gray))
                .offset(x: 100, y: model.hostTurn ? lessScreenHeight : -lessScreenHeight)
            }
        }
        .statusBar(hidden: true)
    }
}

func timeStateView(timeState: TimeState, time: TimeInterval) -> some View {
    return VStack {
        if timeState == .outOfTime {
            Text("哈哈，你超时了").font(.system(size: 50))
        }
        else if timeState ==  .running {
            Text(formatTime(time)).font(.system(size: 50))
        }
        else if timeState == .resumming {
            Text(formatTime(time)).font(.system(size: 50))
            Text("点击继续计时").font(.system(size: 30))
        }
        else {
            // timeState == .starting:
            Text(formatTime(time)).font(.system(size: 50))
            Text("点击开始计时").font(.system(size: 30))
        }
    }
//    switch timeState {
//    case .outOfTime:
//        return Text("哈哈，你超时了").font(.system(size: 50))
//    case .running:
//        return Text(formatTime(time)).font(.system(size: 50))
//    case .resumming:
//        return Text(formatTime(time) + "\n点击继续计时").font(.system(size: 50))
//    case .starting:
//        return Text(formatTime(time) + "\n点击开始计时").font(.system(size: 50))
//    }
}

struct TurnTimerView: View {
    let hostSide: Bool
    @EnvironmentObject var model: TimerModel
    
    var body: some View {
        VStack {
            timeStateView(timeState: hostSide ? model.hostState : model.guestState,
                          time: hostSide ? model.hostTime : model.guestTime )
            if model.hostPhase != nil {
                Text("读秒：\(hostSide ? Int(model.hostPhase!.0) : Int(model.guestPhase!.0))，\(hostSide ? model.hostPhase!.1 : model.guestPhase!.1)次").offset(y: hostSide == model.hostTurn ? 60 : 20).font(.system(size: 20))
            }
        }
        .foregroundColor(hostSide ? .white : .black)
        .rotationEffect(hostSide ?  Angle(degrees: 180) : .zero)
        .frame(width: screenWidth, height: hostSide == model.hostTurn ? moreScreenHeight : lessScreenHeight)
        .background(hostSide ? Color.black.edgesIgnoringSafeArea(.all) : Color.white.edgesIgnoringSafeArea(.all))
        .onTapGesture {
            self.model.tap(onHost: self.hostSide)
        }
    }
}

// 将秒数转换为显示时间
func formatTime(_ time: TimeInterval) -> String {
    var t = Int(time)
    var result = ""
    
    var x = Int(t / (60 * 60))
    if x >= 1 {
        result += "\(x):"
        t -= x * 60 * 60
    }
    
    x = Int(t / 60)
    if x >= 10 {
        result += "\(x):"
    } else {
        result += "0\(x):"
    }
    t -= x * 60
    
    if t >= 10 {
        result += "\(t)"
    } else {
        result += "0\(t)"
    }
    
    return result
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(TimerModel())
//            .environment(\.colorScheme, .light)
    }
}
