//
//  ByoyomiListView.swift
//  GoClock
//
//  Created by Zheng Kanyan on 2020/11/6.
//  Copyright © 2020 Zheng Kanyan. All rights reserved.
//

import SwiftUI
import SwipeCell

struct ByoyomiListView: View {
    @Environment(\.presentationMode) var mode
    @EnvironmentObject var store: Store
    @GestureState private var dragOffset = CGSize.zero
    
    @State var showSheet: Bool = false
    @State var selectedIndex: Int?
    
    @State private var numbers = [0, 1, 2, 3]
    
    private var timeControls: AppState.Settings.TimeControls {
        store.appState.settings.timeControls
    }
    
    private func removeRows(indexSet: IndexSet) {
        numbers.remove(atOffsets: indexSet)
        store.dispatch(.deleteByoyomi(index: Int(indexSet.first!)))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(0..<timeControls.byoyomis.count, id: \.self) {
//                ForEach(numbers.indices, id: \.self) {
                    ByoyomiCell(index: $0, showSheet: $showSheet, selectedIndex: $selectedIndex)
                }
//                .onDelete { indexSet in
//                    removeRows(indexSet: indexSet)
//                }
            }
        }
        .gesture(
            DragGesture().updating(
                $dragOffset,
                body: { (value, state, transaction) in
                    if(value.startLocation.x < 20 && value.translation.width > 100) {
                        self.mode.wrappedValue.dismiss()
                    }
                }
            )
        )
        .navigationTitle("Byoyomis")
        .sheet(isPresented: $showSheet, content: {
            if let index = selectedIndex {
                ByoyomiSetting(in: selectedIndex, byoyomi: timeControls.byoyomis[index])
            } else {
                ByoyomiSetting(in: nil, byoyomi: Byoyomi.defaultByoyomi)
            }
        })
        .toolbar(content: {
            Button(action: {
                selectedIndex = nil
                showSheet.toggle()
            }, label: {
                Image(systemName: "plus")
            })
        })
    }
}

struct ByoyomiCell: View {
    @Environment(\.presentationMode) var mode
    @EnvironmentObject var store: Store
    let index: Int
    @Binding var showSheet: Bool
    @Binding var selectedIndex: Int?
    
    private var timeControls: AppState.Settings.TimeControls {
        store.appState.settings.timeControls
    }
    private var byoyomi: Byoyomi? {
        if timeControls.byoyomis.indices.contains(index) {
            return timeControls.byoyomis[index]
        } else {
            return nil
        }
    }
    private var currentUsing: Bool {
        index == timeControls.currentIndex
    }
    
    var body: some View {
        let editButton = SwipeCellButton(
            buttonStyle: .title,
            title: "Edit",
            systemImage: nil,
            view: nil,
            backgroundColor: .green) {
                selectedIndex = index
                showSheet.toggle()
            }
        let deleteButton = SwipeCellButton(
            buttonStyle: .title,
            title: "Delete",
            systemImage: nil,
            view: nil,
            backgroundColor: .red) {
                store.dispatch(.deleteByoyomi(index: index))
            }
        if let _ = byoyomi {
            HStack {
                VStack {
                    ByoyomiView(byoyomi: byoyomi!)
                }
                Spacer()
                Button("Select") {
                    store.dispatch(.selectCurrentByoyomi(index: index))
                    self.mode.wrappedValue.dismiss()
                }
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 20))
            .background(currentUsing ? Color(UIColor.secondarySystemBackground) : .clear)
            .onTapGesture {
                selectedIndex = index
                showSheet.toggle()
            }
            .swipeCell(cellPosition: .right, leftSlot: nil, rightSlot: SwipeCellSlot(slots: [editButton, deleteButton]))
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store()
        store.appState.settings.timeControls.byoyomis = [
            Byoyomi(name: "v1", mainTime: 10, periodTime: 10, periodNumber: 3),
            Byoyomi(name: "v2", mainTime: 10, periodTime: 10, periodNumber: 3),
            Byoyomi(name: "v3", mainTime: 10, periodTime: 10, periodNumber: 3),
        ]
        return ByoyomiListView().environmentObject(store)
    }
}
