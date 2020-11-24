//
//  Settings.swift
//  GoClock
//
//  Created by Zheng Kanyan on 2020/9/26.
//  Copyright © 2020 Zheng Kanyan. All rights reserved.
//

import SwiftUI

struct Settings: View {
    @State var navBarHidden: Bool = true
    
    @State var showResetAlert = false
    @State var enableClickSound = true
    @State var alwaysShowTurnNumber = false
    @State var airplaneModeReminder = true
    
    @EnvironmentObject var store: Store
    private var appState: AppState {
        store.appState
    }
    private var settings: AppState.Settings {
        store.appState.settings
    }
    private var byoyomi: Byoyomi {
        store.appState.settings.timeControls.currentByoyomi
    }
    private func dismissModal() {
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "dismissModal"),
            object: nil
        )
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                Text("Byoyomi")
                    .padding()
//                Divider()
                NavigationLink(
                    destination: ByoyomiListView(),
                    label: {
                        HStack {
                            ByoyomiView(byoyomi: byoyomi)
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 10))
                        .background(Color(UIColor.systemBackground))
                    }
                )
                Toggle("Enable Click Sound", isOn: $enableClickSound)
                    .onAppear {
                        enableClickSound = settings.enableClickSound
                    }
                    .padding()
                Toggle("Always Show Turn Number", isOn: $alwaysShowTurnNumber)
                    .onAppear {
                        alwaysShowTurnNumber = settings.alwaysShowTurnNumber
                    }
                    .padding()
//                Toggle("Airplane Mode Reminder", isOn: $airplaneModeReminder)
//                    .onAppear {
//                        airplaneModeReminder = settings.airplaneModeReminder
//                    }
//                    .padding()
//                Divider()
                Spacer()
            }
            .background(Color(UIColor.secondarySystemBackground))
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Done") {
                    store.dispatch(
                        .updateSettings(
                            enableClickSound: enableClickSound,
                            alwaysShowTurnNumber: alwaysShowTurnNumber,
                            airplaneModeReminder: airplaneModeReminder
                        )
                    )
                    if appState.usingCurrentByoyomi {
                        dismissModal()
                    } else {
                        if appState.clockState.playState == .ready {
                            store.dispatch(.reset)
                            dismissModal()
                        } else {
                            showResetAlert = true
                        }
                    }
                }
            }
        }
        .alert(isPresented: $showResetAlert) {
            Alert(title: Text("Time Control was modified, do you want to reset timer?"), primaryButton: .default(Text("Yes")) {
                store.dispatch(.reset)
                dismissModal()
            }, secondaryButton: .cancel(Text("Cancel"), action: {
                dismissModal()
            }))
        }
    }
}

struct ByoyomiView: View {
    let byoyomi: Byoyomi
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(byoyomi.name)
                .foregroundColor(.primary)
            VStack(alignment: .leading) {
                Text("Main Time: \(timeStamp(from: byoyomi.mainTime))")
                Text("Period Time: \(timeStamp(from: byoyomi.periodTime))")
                Text("Period Number: \(byoyomi.periodNumber) times")
            }
            .foregroundColor(.secondary).font(.subheadline)
            .padding(.leading, 15)
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store()
        store.appState.settings.timeControls.byoyomis = [
            Byoyomi(name: "v1", mainTime: 10, periodTime: 10, periodNumber: 3),
            Byoyomi(name: "v2", mainTime: 10, periodTime: 10, periodNumber: 3),
            Byoyomi(name: "v3", mainTime: 10, periodTime: 10, periodNumber: 3),
        ]
        return Settings()
            .environmentObject(store)
    }
}
