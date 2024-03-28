//
//  AnswerDetailView.swift
//  ARI
//
//  Created by 기 표 on 3/27/24.
//

import SwiftUI

struct AnswerDetailView: View {
    
    var answer: String
    @EnvironmentObject private var questionModel: QuestionViewModel
    @EnvironmentObject private var loginViewModel: LoginViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State var question: QuestionData = QuestionData(id: "d", question: "qq")
    
    @State private var isShowingEditView = false
    @State private var isLogin = false
    @State var selectedQuestionIndex: Int = 0
    @State var recentQuestion: QuestionData
    
    @Binding var myAnswerExample: [String]
    @Binding var otherAnswerExample: [String]
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Text("for question in questions {") // 코드 블록 시작 부분 표시
                            .foregroundStyle(.accent)
                        Spacer()
                    }
                    .padding(.vertical, 20)
                    
                    // MARK: - 질문
                    if !recentQuestion.question.isEmpty {
                        MyQuestionCell(number: 0, question: recentQuestion)
                    } else {
                        Text("문제가 없습니다")
                    }
                    
                    HStack {
                        Text("myAnswer()") // 사용자 답변 표시
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
                        Text("otherAnswer()") // 다른 답변 표시
                            .foregroundStyle(.accent)
                        Spacer()
                    }
                    
                    LazyVStack {
                        //                        ForEach(recentQuestion) { question in
                        //                                if selectedQuestionIndex < otherAnswerExample.count {
                        //                                    AnswerCell(answer: otherAnswerExample[selectedQuestionIndex])
                        //                                        .padding(.bottom, 30)
                        //                                } else {
                        //                                    AnswerCell(answer: "답변이 없습니다")
                        //                                        .padding(.bottom, 30)
                        //                                }
                        //                            }
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
        .task {
            let getRandomQuestion = await questionModel.getRandomQuestion()
            DispatchQueue.main.async {
                recentQuestion = getRandomQuestion
                
            }
        }
        .toolbar {
            if selectedQuestionIndex < myAnswerExample.count && isLogin == true {
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
            
        }
        .navigationTitle("최근 답변")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $isShowingEditView) {
            EditAnswerView(isShowingEditView: $isShowingEditView, myAnswerExample: $myAnswerExample, recentQuestion: $recentQuestion, selectedAnswerIndex: selectedQuestionIndex)
        }
    }
}

//#Preview {
//    AnswerDetailView(answer: "123", myAnswerExample: .constant["Asd"], otherAnswerExample: .constant["Asd"])
//        .preferredColorScheme(.dark)
//}
