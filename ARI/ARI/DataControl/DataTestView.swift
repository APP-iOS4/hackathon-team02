//
//  DataTestView.swift
//  ARI
//
//  Created by Healthy on 3/27/24.
//

import SwiftUI

struct DataTestView: View {
    @EnvironmentObject private var questionModel: QuestionViewModel
    @EnvironmentObject private var loginViewModel: LoginViewModel
    
    @State var question: QuestionData = QuestionData(id: "d", question: "qq")
    @State var isLogin: Bool = false
    @State var myAnswer = ""
    @State var others: [String] = []
    @State var myQuestion: [QuestionData] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text(question.question)
                
                Text("\(isLogin)")
                
                Button {
                    question = questionModel.getRandomQuestion()
                } label: {
                    Text("문제 가져오기 버튼")
                }
                
                Button {
                    loginViewModel.loginGoogle {
                        isLogin = loginViewModel.isSignedIn
                        
                        Task {
                            await questionModel.loadMyAnsweredQuestion()
                            myQuestion = questionModel.answeredQuestions
                        }
                    }
                } label: {
                    Text("로그인 버튼")
                }
                
                Button {
                    loginViewModel.logoutGoogle {
                        isLogin = loginViewModel.isSignedIn
                        Task {
                            await questionModel.loadMyAnsweredQuestion()
                            myQuestion = questionModel.answeredQuestions
                        }
                    }
                } label: {
                    Text("로그아웃 버튼")
                }
                
                Button {
                    questionModel.addAnswer(answer: "대.답33333", userID: loginViewModel.userInfo!.id, questionID: question.id)
                } label: {
                    Text("내 답변 버튼")
                }
                
                
                Text(myAnswer)
                
                Button {
                    Task {
                        myAnswer = await questionModel.loadMyAnswer(questionID: question.id, userID: loginViewModel.userInfo!.id)
                    }
                } label: {
                    Text("내 답변 불러오기 버튼")
                }
                
                Button {
                    Task {
                        others = await questionModel.loadOthersAnswer(questionID: question.id, userID: loginViewModel.userInfo!.id)
                    }
                } label: {
                    Text("다른사람 답 불러오기 버튼")
                }
                
                ForEach (0..<myQuestion.count, id: \.self) { index in
                    Text(myQuestion[index].question)
                        .foregroundStyle(.white)
                        .font(.largeTitle)
                }
            }
        }
        .onAppear {
            isLogin = loginViewModel.isSignedIn
        }
    }
}

#Preview {
    DataTestView()
        .environmentObject(QuestionViewModel())
        .environmentObject(LoginViewModel())
}
