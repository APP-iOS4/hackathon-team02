//
//  AnswerDetailView.swift
//  ARI
//
//  Created by 기 표 on 3/27/24.
//

import SwiftUI
struct Question: Identifiable {
    var id: Int
    var question: String
}

struct AnswerDetailView: View {
    @State private var questionHeight: CGFloat = .zero
    @State private var answerHeight: CGFloat = .zero
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Text("for question in questions {")
                            .foregroundStyle(.accent)
                        Spacer()
                    }
                    .padding(.vertical, 20)
                    ZStack {
                        RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                            .foregroundStyle(.background2)
                            .frame(height: questionHeight + 55)
                        
                        //MARK: - 문제
                        VStack(alignment: .leading, spacing: 10) {
                            Text("#0")
                                .foregroundStyle(.accent)
                            
                            Text("Swift 언어에서 클래스(class)와 구조체(struct)의 차이를 설명하세요.")
                                .background(
                                    GeometryReader { geometry in
                                        Color.clear.onAppear {
                                            questionHeight = geometry.size.height
                                        }
                                    }
                                )
                        }
                        .font(.title3)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 25)
                    }
                    .padding(.bottom, 40)
                    
                    ZStack {
                        RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                            .foregroundStyle(.background2)
                            .frame(height: answerHeight + 50)
                        
                        //MARK: - 문제
                        
                        VStack {
                            Text("답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다.")
                                .font(.title3)
                                .background(
                                    GeometryReader { geometry in
                                        Color.clear.onAppear {
                                            answerHeight = geometry.size.height
                                        }
                                    }
                                )
                        }
                        .padding(.leading)
                        .foregroundStyle(.white)
                        Spacer()
                        
                        
                        
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        Text("}")
                            .foregroundStyle(.accent)
                    }
                }
                .navigationTitle("나의 답변")
                .navigationBarTitleDisplayMode(.inline)
                .fontDesign(.monospaced)
                .toolbar(.hidden, for: .tabBar)
                .padding(10)
            }
        }
    }
}


#Preview {
    AnswerDetailView()
        .preferredColorScheme(.dark)
}
