//
//  TimePickerView.swift
//  GoClock
//
//  Created by Zheng Kanyan on 2020/9/11.
//  Copyright © 2020 Zheng Kanyan. All rights reserved.
//

import SwiftUI

class SelectedTime: ObservableObject {
    @Published var selectedHours = 0
    @Published var selectedMinutes = 0
    @Published var selectedSeconds = 0
    
    var realTime: Int {
        selectedHours * 3600 + selectedMinutes * 60 + selectedSeconds
    }
    
    init(_ hours: Int = 0, _ minutes: Int = 0, _ seconds: Int = 0) {
        selectedHours = hours
        selectedMinutes = minutes
        selectedSeconds = seconds
    }
    
    init(_ totalSeconds: Int = 0) {
        selectedHours = totalSeconds / 3600
        selectedMinutes = (totalSeconds - 3600 * selectedHours) / 60
        selectedSeconds = (totalSeconds - 3600 * selectedHours - 60 * selectedMinutes)
    }
}

struct SelectTimeView: View {
    private let title: String
    @ObservedObject var selectedTime: SelectedTime
    @State var showPicker = false
    
    init(title: String, selectedTime: SelectedTime) {
        self.title = title
        self.selectedTime = selectedTime
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("\(title): \(timeStamp(from: selectedTime.realTime))")
                Spacer()
                Image(systemName: "chevron.right")
            }
            .contentShape(Rectangle())
            .onTapGesture {
                showPicker.toggle()
            }
            if showPicker {
                TimePickerView(selectedTime)
                    .frame(height: 180)
            }
        }
        .padding()
//        .background(Color.clear)
    }
}

struct TimePickerView: View {
    
    @ObservedObject private var selectedTime: SelectedTime
    
    private var maxHours: Int
    private var maxMinutes: Int
    
    init(_ selectedTime: SelectedTime, maxHours: Int = 12, maxMinutes: Int = 60) {
        self.maxHours = maxHours
        self.maxMinutes = maxMinutes
        self.selectedTime = selectedTime
    }
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                HStack(spacing: 0) {
                    Picker(selection: $selectedTime.selectedHours, label: Text("")) {
                        ForEach(0..<self.maxHours) {
                            Text("\($0) Hours")
                        }
                    }
                    .frame(width: proxy.size.width / 3, height: proxy.size.height)
                    .clipped()
                    Picker(selection: $selectedTime.selectedMinutes, label: Text("")) {
                        ForEach(0..<self.maxMinutes) {
                            Text("\($0) Minutes")
                        }
                    }
                    .frame(width: proxy.size.width / 3, height: proxy.size.height).clipped()
                    Picker(selection: $selectedTime.selectedSeconds, label: Text("")) {
                        ForEach(0..<60) {
                            Text("\($0) Seconds")
                        }
                    }
                    .frame(width: proxy.size.width / 3, height: proxy.size.height).clipped()
                }
//                .border(Color.orange, width: 2)
            }
        }
    }
}

struct TestTimePickerView: View {
    @ObservedObject var selectedTime: SelectedTime = SelectedTime()
    @State var showPicker = false
    @State var name: String = "oo"
    
    var body: some View {
        VStack {
            Form {
                Button(action: {
                    showPicker.toggle()
                }, label: {
                    Text("Button")
                })
                Button(action: {
                    showPicker.toggle()
                }, label: {
                    Text("Button")
                })
                TextField("xi", text: $name)
            }.frame(width: screenWidth, height: 150)
            if showPicker {
                TimePickerView(selectedTime)
                    .frame(width: 300, height: 185)
            }
        }
    }
}

struct TimePickerView_Previews: PreviewProvider {
    
    static var previews: some View {
//        TestTimePickerView()
        SelectTimeView(title: "基本时间", selectedTime: SelectedTime(548))
    }
}
