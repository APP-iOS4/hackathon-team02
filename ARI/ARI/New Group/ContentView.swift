//
//  ContentView.swift
//  ARI
//
//  Created by Healthy on 3/27/24.
//

import SwiftUI

struct ContentView: View {
    @State var selectedPage: Int = 0
    
    var body: some View {
        TabView(selection: $selectedPage) {
            HomeView()
                .tabItem {
                    Image(systemName: "questionmark.app")
                    Text("오늘의 질문")
                        
                }
                .tag(0)
            
            MyAnswerView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("나의 답변")
                }
                .tag(0)
        }
        
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
