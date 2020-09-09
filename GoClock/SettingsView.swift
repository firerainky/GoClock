//
//  SettingsView.swift
//  GoClock
//
//  Created by Zheng Kanyan on 2020/9/8.
//  Copyright © 2020 Zheng Kanyan. All rights reserved.
//

import SwiftUI

let timeStart = Date(timeIntervalSince1970: 0)
let timeEnd = Date(timeIntervalSince1970: 360 * 6)
let timeEnd2 = Date(timeIntervalSince1970: 360)


struct SettingsView: View {
    @Environment(\.presentationMode) var mode
    @EnvironmentObject var model: TimerModel
    var freeTime: String
    let countDownTime: TimeInterval
    let countDownNum: Int
    
    init(freeTime: TimeInterval, countDownTime: TimeInterval, countDownNum: Int) {
        
        self.freeTime = String(freeTime)
        self.countDownTime = countDownTime
        self.countDownNum = countDownNum
    }
    
    var body: some View {
        VStack {
            Button(action: {
                self.mode.wrappedValue.dismiss()
            }) {
                Text("完成")
            }
//            TextField("时间", text: $freeTime)
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(freeTime: 15, countDownTime: 15, countDownNum: 3)
    }
}
