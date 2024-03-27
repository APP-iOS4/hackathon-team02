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
    @Environment(\.dismiss) var dismiss
    @State private var isShowingEditView = false

    var number: Int
    var question: String
    var answer: String
    
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
                            Text("#\(number)")
                                .foregroundStyle(.accent)
                            
                            Text("\(question)")
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
                    
                    HStack {
                        Text("    myAnswer()")
                            .foregroundStyle(.accent)
                        Spacer()
                    }
                    AnswerCell(answer: answer)
                        .padding(.bottom, 40)
                    Spacer()
                    
                    HStack {
                        Text("    otherAnswer()")
                            .foregroundStyle(.accent)
                        Spacer()
                    }
                    
                    LazyVStack {
                        ForEach(1..<13) { item in
                            AnswerCell(answer: answer)
                                .padding(.bottom)
                        }
                    }
                    HStack {
                        Text("}")
                            .foregroundStyle(.accent)
                        Spacer()
                    }
                    .padding(.vertical, 20)
                }
                .navigationTitle("나의 답변")
                .navigationBarTitleDisplayMode(.inline)
                .fontDesign(.monospaced)
                .toolbar(.hidden, for: .tabBar)
                .padding(10)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Button(action: {
                                isShowingEditView.toggle()
                            }, label: {
                                Label("수정하기", systemImage: "square.and.pencil")
                            })
                            Button(role: .destructive) {
                                dismiss()
                            } label: {
                                Label("삭제하기", systemImage: "trash")
                            }
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15)
                                .rotationEffect(.degrees(90))
                                .foregroundStyle(.accent)
                        }
                    }
                    
                }
                .fullScreenCover(isPresented: $isShowingEditView) {
                    EditAnswerView(isShowingEditView: $isShowingEditView)
                }
            }
        }
    }
}


#Preview {
    AnswerDetailView(number: 0, question: "Swift 언어에서 클래스(class)와 구조체(struct)의 차이를 설명하세요.", answer: "답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다.")
        .preferredColorScheme(.dark)
}
