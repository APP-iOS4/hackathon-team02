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
            QuestionView()
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
                .tag(1)
            
            MoreInfoView()
                .tabItem {
                    Image(systemName: "info.square")
                    Text("더 보기")
                }
                .tag(2)
            
            DataTestView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("데이터 테스트")
                }
                .tag(3)
        }
        
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
