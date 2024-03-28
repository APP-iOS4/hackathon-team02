//
//  AnswerDetailView.swift
//  ARI
//
//  Created by 기 표 on 3/27/24.
//

import SwiftUI

struct AnswerDetailView: View {
    var answer: String
    @StateObject private var questionModel = QuestionViewModel()
    @StateObject private var loginViewModel = LoginViewModel()
    
    @Namespace private var namespace
    @State private var isShowingEditView = false
    @State private var selectedQuestionIndex: Int = 0
    @State private var myAnswerExample: [String] = []
    @State private var otherAnswerExample: [String] = []
    
    @State private var recentQuestion: [QuestionData] = [.init(id: "123", question: "Example Recent Question")]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Text("for question in \(recentQuestion.map { $0.question }) {")
                            .font(.subheadline)
                            .foregroundStyle(.accent)
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 20, leading: 10, bottom: 0, trailing: 10))
                    
                    if !recentQuestion.isEmpty {
                        MyQuestionCell(number: 0, question: recentQuestion[0])
                    } else {
                        Text("문제가 없습니다")
                    }
                    
                    HStack {
                        Text("myAnswer()")
                            .foregroundStyle(.accent)
                        Spacer()
                    }
                    
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
                            .font(.subheadline)
                            .foregroundStyle(.accent)
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
                }
                .fontDesign(.monospaced)
                .background(Color.backGround)
                .padding(10)
            }
            .padding(1)
            .fontDesign(.monospaced)
        }
        .onAppear {
            Task {
                if let userID = loginViewModel.userInfo?.id {
                    let myAnswer = await questionModel.loadMyAnswer(questionID: recentQuestion[selectedQuestionIndex].id, userID: userID)
                    let othersAnswer = await questionModel.loadOthersAnswer(questionID: recentQuestion[selectedQuestionIndex].id, userID: userID)
                    
                    myAnswerExample = [myAnswer]
                    otherAnswerExample = othersAnswer
                } else {
                    print("유저 정보 없음")
                }
            }
        }
        .navigationTitle("최근 답변")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !myAnswerExample.isEmpty && loginViewModel.isSignedIn {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            isShowingEditView.toggle()
                        }, label: {
                            Label("수정하기", systemImage: "square.and.pencil")
                        })
                        Button(role: .destructive) {
                            // TODO: - 삭제 기능 추가
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
        .fullScreenCover(isPresented: $isShowingEditView) {
            EditAnswerView(isShowingEditView: $isShowingEditView, myAnswerExample: $myAnswerExample, recentQuestion: $recentQuestion, selectedAnswerIndex: selectedQuestionIndex)
        }
    }
}

#Preview {
    AnswerDetailView(answer: "123")
               .preferredColorScheme(.dark)
               .environmentObject(LoginViewModel())
               .environmentObject(QuestionViewModel())
}
