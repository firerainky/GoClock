//
//  TimePickerView.swift
//  GoClock
//
//  Created by Zheng Kanyan on 2020/9/11.
//  Copyright © 2020 Zheng Kanyan. All rights reserved.
//

import SwiftUI

struct TimePickerView: View {
    @State var selectedHours = 0
    @State var selectedMinutes = 0
    @State var selectedSeconds = 0
    
    @State var duration: TimeInterval = 0
    
    private var maxHours: Int
    private var maxMinutes: Int
    
    init(maxHours: Int = 12, maxMinutes: Int = 60) {
        self.maxHours = maxHours
        self.maxMinutes = maxMinutes
    }
    
    var body: some View {
        GeometryReader { proxy in
            HStack {
                Picker(selection: self.$selectedHours, label: Text("")) {
                    ForEach(0..<self.maxHours) {
                        Text("\($0) 小时")
                    }
                }.frame(width: proxy.size.width / 3).clipped()
                Picker(selection: self.$selectedMinutes, label: Text("")) {
                    ForEach(0..<self.maxMinutes) {
                        Text("\($0) 分钟")
                    }
                    }.frame(width: proxy.size.width / 3).clipped()
                Picker(selection: self.$selectedSeconds, label: Text("")) {
                    ForEach(0..<60) {
                        Text("\($0) 秒")
                    }
                    }.frame(width: proxy.size.width / 3).clipped()
            }
        }
    }
}

struct TimePickerView_Previews: PreviewProvider {
    static var previews: some View {
        TimePickerView()
    }
}
