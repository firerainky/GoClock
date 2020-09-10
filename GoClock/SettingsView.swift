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
    
    @State var freeTimeStr: String = ""
    @State var countDownTimeStr: String = ""
    @State var countDownNumStr: String = ""
    
    init(freeTime: TimeInterval, countDownTime: TimeInterval, countDownNum: Int) {
        freeTimeStr = String(Int(freeTime))
        countDownTimeStr = String(Int(countDownTime))
        countDownNumStr = String(countDownNum)
    }
    
    var body: some View {
        Form {
            Button(action: {
                let freeTime = Int(self.freeTimeStr)
                let countDownTime = Int(self.countDownTimeStr)
                let countDownNum = Int(self.countDownNumStr)
                self.model.setNewRule(freeTime: freeTime!, countDownTime: countDownTime!, countDownNum: countDownNum!)
                self.mode.wrappedValue.dismiss()
            }) {
                Text("完成")
            }
            HStack {
                Text("时间")
                Spacer()
                TextField("时间", text: $freeTimeStr)
                    .keyboardType(.numberPad)
            }
            HStack {
                Text("读秒")
                Spacer()
                TextField("读秒", text: $countDownTimeStr)
                    .keyboardType(.numberPad)
            }
            HStack {
                Text("次数")
                Spacer()
                TextField("次数", text: $countDownNumStr)
                    .keyboardType(.numberPad)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(freeTime: 15, countDownTime: 15, countDownNum: 3)
    }
}
