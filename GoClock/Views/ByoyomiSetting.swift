//
//  ByoyomiSetting.swift
//  GoClock
//
//  Created by Zheng Kanyan on 2020/9/27.
//  Copyright © 2020 Zheng Kanyan. All rights reserved.
//

import SwiftUI

struct ByoyomiSetting: View {
    @Environment(\.presentationMode) var mode
    @EnvironmentObject var store: Store
    
    let byoyomi: Byoyomi
    let index: Int?
    @State var expandingIndex: Int?
    
    @ObservedObject var selectedMainTime: SelectedTime
    @ObservedObject var selectedPeriodTime: SelectedTime
    @State var name: String = ""
    @State var selectedNumber: Int = 0
    
    init(in index: Int?, byoyomi: Byoyomi) {
        self.byoyomi = byoyomi
        self.index = index
        selectedMainTime = SelectedTime(byoyomi.mainTime)
        selectedPeriodTime = SelectedTime(byoyomi.periodTime)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.mode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.down")
                })
                Spacer()
                Button(action: {
                    store.dispatch(
                        .updateByoyomi(in: index, with:
                            Byoyomi(name: name,
                                    mainTime: selectedMainTime.realTime,
                                    periodTime: selectedPeriodTime.realTime, periodNumber: selectedNumber
                            )
                        )
                    )
                    self.mode.wrappedValue.dismiss()
                }, label: {
                    Text("Done")
                })
            }
            .padding()
            
            
            TextField(NSLocalizedString("Input byoyomi's name", comment: ""), text: $name) {
                if $0 {
                    expandingIndex = nil
                }
            } onCommit: { }
                .font(.title2)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .introspectTextField { textField in
//                    textField.becomeFirstResponder()
                }
                .onAppear(perform: {
                    name = byoyomi.name
                })
            
            
            VStack {
                HStack {
                    Text("\(NSLocalizedString("Main Time", comment: "")): \(timeStamp(from: selectedMainTime.realTime))")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if let i = expandingIndex, i == 0 {
                        expandingIndex = nil
                    } else {
                        UIApplication.shared.endEditing()
                        expandingIndex = 0
                    }
                }
                if let i = expandingIndex, i == 0 {
                    TimePickerView(selectedMainTime)
                        .frame(height: 180)
                }
            }.padding().background(Color.white)
            
            VStack {
                HStack {
                    Text("\(NSLocalizedString("Period Time", comment: "")): \(selectedNumber) times")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if let i = expandingIndex, i == 1 {
                        expandingIndex = nil
                    } else {
                        UIApplication.shared.endEditing()
                        expandingIndex = 1
                    }
                }
                if let i = expandingIndex, i == 1 {
                    TimePickerView(selectedMainTime)
                        .frame(height: 180)
                }
            }.padding().background(Color.white)
            
            VStack {
                HStack {
                    Text("\(NSLocalizedString("Period Number", comment: "")): \(timeStamp(from: selectedMainTime.realTime))")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if let i = expandingIndex, i == 2 {
                        expandingIndex = nil
                    } else {
                        UIApplication.shared.endEditing()
                        expandingIndex = 2
                    }
                }
                if let i = expandingIndex, i == 2 {
                    Picker(selection: $selectedNumber, label: Text("")) {
                        ForEach(2..<10) {
                            Text("\($0)")
                        }
                    }.frame(height: 180)
                }
            }.padding().background(Color.white)
            Spacer()
        }.background(Color(UIColor.secondarySystemBackground))
    }
}

//struct NumberPickerView: View {
//    let title: String
//    let minNumber: Int
//    let maxNumber: Int
//    @Binding var selectedNumber: Int
//    @State var showPicker: Bool = false
//
//    init(title: String, minNumber: Int = 0, maxNumber: Int = 10, selectedNumber: Binding<Int>) {
//        self.title = title
//        self.minNumber = minNumber
//        self.maxNumber = maxNumber
//        self._selectedNumber = selectedNumber
//    }
//
//    var body: some View {
//        VStack {
//            HStack {
//                Text("\(title): \(selectedNumber) times")
//                Spacer()
//                Image(systemName: "chevron.right")
//            }
//            .contentShape(Rectangle())
//            .onTapGesture {
//                showPicker.toggle()
//            }
//            if showPicker {
//                Picker(selection: $selectedNumber, label: Text("")) {
//                    ForEach(minNumber..<maxNumber) {
//                        Text("\($0)")
//                    }
//                }.frame(height: 180)
//            }
//        }
//        .padding()
//    }
//}

struct ByoyomiSetting_Previews: PreviewProvider {
//    @EnvironmentObject var store: Store =
    
    static var previews: some View {
        ByoyomiSetting(in: nil, byoyomi: Byoyomi.defaultByoyomi).environmentObject(Store())

    }
}
