//
//  NextSetting.swift
//  GoClock
//
//  Created by Zheng Kanyan on 2020/11/4.
//  Copyright © 2020 Zheng Kanyan. All rights reserved.
//

import SwiftUI

struct ContentsView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination : MenuView()) {
                    Text("Settings")
                }
            }
            .navigationBarTitle("Title")
        }
    }
}

struct MenuView : View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffset = CGSize.zero
    
    var body : some View {
        VStack {
            Text("Settings")
                .foregroundColor(Color.white)
                
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: Button(action : {
                    self.mode.wrappedValue.dismiss()
                }){
                    Image(systemName: "arrow.left")
                        .foregroundColor(Color.white)
                })
                .frame(maxWidth: .infinity, maxHeight : .infinity)
                .background(Color.blue)
                
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
        
            if(value.startLocation.x < 20 && value.translation.width > 100) {
                self.mode.wrappedValue.dismiss()
            }
            
        }))
    }
}

struct NextSetting_Previews: PreviewProvider {
    static var previews: some View {
        ContentsView()
    }
}
