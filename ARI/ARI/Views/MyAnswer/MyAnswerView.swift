//
//  MyAnswer.swift
//  ARI
//
//  Created by Healthy on 3/27/24.
//

import SwiftUI

struct MyAnswerView: View {
    @Namespace private var namespace
    @State private var isShowingRecent: Bool = true
    
    @State var exampleRecent: [String] = ["Swift언어에서의 구조체(struct)와 클래스(class)의 차이는 무엇인지 설명하세요. ", "SwiftUI에서의 @EnvironmentObject의 장단점을 설명하세요. ", "UIKit과 SwiftUI의 차이가 무엇인지 3가지 설명하세요. ", "@StateObject와 @ObservableObject의 차이가 무엇인지 설명하세요. "]
    @State var exampleFavorite: [String] = ["HTML이 왜 프로그래밍 언어가 아닌지 설명하세요. ","UIKit의 MVC 구조에서 각 요소는 어떤 역할을 하는지 설명하세요. "]
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    ZStack(alignment: .center) {
                        Text("최근 답변")
                            .fontWeight(.bold)
                            .foregroundStyle(isShowingRecent ? .accent : .text )
                            .background{
                                if isShowingRecent {
                                    Rectangle()
                                        .foregroundStyle(isShowingRecent ? .accent : .clear)
                                        .matchedGeometryEffect(id: "category", in: namespace)
                                        .frame(height: 2)
                                        .offset(y: 15)
                                }
                            }
                            .padding(EdgeInsets(top: 5, leading: 20, bottom: 10, trailing: 20))
                    }
                    .onTapGesture {
                        withAnimation(.spring()) {
                            isShowingRecent = true
                        }
                        
                    }
                    
                    ZStack(alignment: .center) {
                        Text("즐겨찾기")
                            .fontWeight(.bold)
                            .foregroundStyle(!isShowingRecent ? .accent : .text )
                            .background{
                                if !isShowingRecent {
                                    Rectangle()
                                        .foregroundStyle(!isShowingRecent ? .accent : .clear)
                                        .matchedGeometryEffect(id: "category", in: namespace)
                                        .frame(height: 2)
                                        .offset(y: 15)
                                }
                            }
                            .padding(EdgeInsets(top: 5, leading: 20, bottom: 10, trailing: 20))
                    }
                    .onTapGesture {
                        withAnimation(.spring()) {
                            isShowingRecent = false
                        }
                    }
                }
                
                ScrollView {
                    LazyVStack {
                        HStack {
                            Text("for question in \(isShowingRecent ? "recentAnswers" : "favorites") {")
                                .font(.subheadline)
                                .foregroundStyle(.accent)
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 15, leading: 10, bottom: 0, trailing: 10))
                        if isShowingRecent {
                            ForEach(exampleRecent, id: \.self) { string in
                                NavigationLink {
                                    Text("\(string)")
                                } label: {
                                    AnswerLabelView(number: exampleRecent.count - (exampleRecent.firstIndex(of: string) ?? 0) - 1, question: string)
                                }
                                .contextMenu {
                                    Button(role: .destructive) {
                                        if let index = exampleRecent.firstIndex(of: string) {
                                            exampleRecent.remove(at: index)
                                        }
                                    } label: {
                                        Label("삭제", systemImage: "trash")
                                    }
                                }
                            }
                        } else {
                            ForEach(exampleFavorite, id: \.self) { string in
                                NavigationLink {
                                    Text("\(string)")
                                } label: {
                                    AnswerLabelView(number: exampleFavorite.count - (exampleFavorite.firstIndex(of: string) ?? 0) - 1, question: string)
                                }
                                .contextMenu {
                                    Button(role: .destructive) {
                                        if let index = exampleFavorite.firstIndex(of: string) {
                                            exampleFavorite.remove(at: index)
                                        }
                                    } label: {
                                        Label("삭제", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        HStack {
                            Spacer()
                            Text("}⌷")
                                .font(.subheadline)
                                .foregroundStyle(.accent)
                        }
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 15, trailing: 10))
                    }
                    
                }
            }
            .fontDesign(.monospaced)
            .background(.backGround)
        }
    }
}

#Preview {
    MyAnswerView()
        .preferredColorScheme(.dark)
}
