//
//  AnswerDetailView.swift
//  ARI
//
//  Created by 기 표 on 3/27/24.
//

import SwiftUI

struct AnswerDetailView: View {
    
    var answer: QuestionData
    @EnvironmentObject private var questionModel: QuestionViewModel
    @EnvironmentObject private var loginViewModel: LoginViewModel
    
    @Namespace private var namespace
    @State private var isShowingEditView = false
    @State var selectedQuestionIndex: Int = 0
    @State private var myAnswer: String = "123"
    @State private var othersAnswer: [String] = []
    
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
                    
                    // MARK: - 문제
                    MyQuestionCell(number: selectedQuestionIndex, question: answer.question)
                    
                    
                    HStack {
                        Text("myAnswer()")
                            .foregroundStyle(.accent)
                        Spacer()
                    }
                    
                    // MARK: - 내 답변
                    AnswerCell(answer: myAnswer)
                        .padding(.bottom, 30)
                    //                    } else {
                    //                        AnswerCell(answer: )
                    //                            .padding(.bottom, 30)
                    //                    }
                    Spacer()
                    
                    HStack {
                        Text("otherAnswer()")
                            .foregroundStyle(.accent)
                        Spacer()
                    }
                    
                    // MARK: - 다른 사람 답변
                    LazyVStack {
                        ForEach(othersAnswer.indices, id: \.self) { index in
                            AnswerCell(answer: othersAnswer[index])
                                .padding(.bottom, 30)
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
            .background(Color.backGround)
        }
        .onAppear {
            Task {
                if let userID = loginViewModel.userInfo?.id {
                    myAnswer = await questionModel.loadMyAnswer(questionID: answer.id, userID: userID)
                    othersAnswer = await questionModel.loadOthersAnswer(questionID: answer.id, userID: userID)
                } else {
                    print("유저 정보 없음")
                }
            }
        }
        .navigationTitle("나의 답변")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            //            if !myAnswerDummy.isEmpty && loginViewModel.isSignedIn {
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
            //            }
        }
        //        .fullScreenCover(isPresented: $isShowingEditView) {
        //            EditAnswerView(isShowingEditView: $isShowingEditView, my: $myAnswerDummy, recentQuestion: $recentQuestion, selectedAnswerIndex: selectedQuestionIndex)
        //        }
    }
}

//#Preview {
//    AnswerDetailView(answer: "123")
//               .preferredColorScheme(.dark)
//               .environmentObject(LoginViewModel())
//               .environmentObject(QuestionViewModel())
//}
