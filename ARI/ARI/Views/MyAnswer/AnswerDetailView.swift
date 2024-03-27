//
//  AnswerDetailView.swift
//  ARI
//
//  Created by 기 표 on 3/27/24.
//

import SwiftUI

struct AnswerDetailView: View {
    @State private var questionHeight: CGFloat = .zero
    @Environment(\.dismiss) var dismiss
    @State private var isShowingEditView = false
    
    var answer: String
    
    @State var recentQuestion: [String] = []
    @Binding var myAnswerExample: [String]
    @Binding var otherAnswerExample: [String]
    @State var selectedQuestionIndex: Int = 0
    
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
                    
                    // MARK: - 질문
                    MyQuestionCell(recentQuestion: $recentQuestion, selectedQuestionIndex: selectedQuestionIndex)
                    
                    HStack {
                        Text("myAnswer()")
                            .foregroundStyle(.accent)
                        Spacer()
                    }
                    
                    // MARK: - 답변
                    // 선택된 질문 인덱스와 답변의 수 비교
                    if selectedQuestionIndex < myAnswerExample.count {
                        AnswerCell(answer: myAnswerExample[selectedQuestionIndex])
                            .padding(.bottom, 30)
                    } else {
                        AnswerCell(answer: "답변이 없습니다")
                            .padding(.bottom, 30)
                    }
                    Spacer()
                    
                    HStack {
                        Text("otherAnswer()")
                            .foregroundStyle(.accent)
                        Spacer()
                    }
                    
                    LazyVStack {
                        ForEach(recentQuestion.indices, id: \.self) { index in
                            if selectedQuestionIndex < otherAnswerExample.count {
                                AnswerCell(answer: otherAnswerExample[selectedQuestionIndex])
                                    .padding(.bottom, 30)
                            } else {
                                AnswerCell(answer: "답변이 없습니다")
                                    .padding(.bottom, 30)
                            }
                        }
                    }
                    HStack {
                        Text("}⌷")
                            .foregroundStyle(.accent)
                        Spacer()
                    }
                    .padding(.vertical, 20)
                }
                .fontDesign(.monospaced)
                .toolbar(.hidden, for: .tabBar)
                .padding(10)
            }
            .padding(1)
            .fontDesign(.monospaced)
            .background(.backGround)
        }
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
        .navigationTitle("최근 답변")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $isShowingEditView) {
            EditAnswerView(isShowingEditView: $isShowingEditView, myAnswerExample: $myAnswerExample, selectedAnswerIndex: selectedQuestionIndex)
        }
    }
}

//#Preview {
//    AnswerDetailView(answer: "답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다.", exampleRecent: .constant(["Question 1", "Question 2"]), myAnswerExample: .constant(["My Answer"]), otherAnswerExample: .constant(["Other Answer 1", "Other Answer 2"]), selectedQuestionIndex: 0)
//        .preferredColorScheme(.dark)
//}
