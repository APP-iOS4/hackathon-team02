//
//  HomeView.swift
//  ARI
//
//  Created by Healthy on 3/27/24.
//

import SwiftUI

struct QuestionView: View {
    @EnvironmentObject private var questionModel: QuestionViewModel
    @EnvironmentObject private var loginViewModel: LoginViewModel
    
    @AppStorage("isSubmitAnswer") var isSubmitAnswer: Bool = false
    
    @State private var currentTime = Date()
    @State private var isShowingAnsweringView = false
    
    @State private var isShowingLoginAlert = false
    @State private var isLogin = false
    private var userNickname: String {
        if isLogin {
            let userEmail = loginViewModel.userInfo?.email ?? "Unknown@"
            let nickName = userEmail.split(separator: "@").first ?? "Unknown"
            
            return String(nickName)
        } else {
            return "Unknown"
        }
    }
    
    @State var question = ""
    
    @Binding var selectedPage: Int
    
    private let screenWidth = UIScreen.main.bounds.size.width
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("\(currentTime)")
                    .onReceive(timer, perform: { _ in
                        currentTime = Date.now
                    })
                

                HStack {
                    Text("\(userNickname)")
                    Text("~ % ari")
                }
                
                Text("")
                Text("      ###    #######   ####")
                Text("    ##   ##  ##    ##   ## ")
                Text("   ########  #######    ## ")
                Text("   ##    ##  ##   ##    ## ")
                Text("   ##    ##  ##    ##  ####")
                Text("")
                
                HStack {
                    Text("\(userNickname)")
                    Text("~ % today question")
                }
            }
            .fontDesign(.monospaced)
            .foregroundStyle(Color.accent)
            .font(.subheadline)
            .padding(.bottom, 50)
            
            Spacer()
            
            HStack {
                Rectangle()
                    .fill(Color.background2)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        Text("\(question)")
                            .font(.title)
                            .fontDesign(.monospaced)
                            .foregroundStyle(Color.accent)
                            .padding()
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.5)
                    }
            }
            .onAppear {
                Task {
                    await questionModel.fetchQuestions()
                    question = questionModel.getRandomQuestion().question
                }
            }
            
            Spacer()
            
            HStack {
                if isSubmitAnswer {
                    HStack(alignment: .top) {
                        Text("\(userNickname) ~ % ")
                        Text("Answer Submission Completed")
                    }
                } else {
                    HStack {
                        Text("\(userNickname)")
                        Text("~ %")
                    }
                }
            }
            .fontDesign(.monospaced)
                .foregroundStyle(Color.accent)
                .font(.subheadline)
                .padding(EdgeInsets(top: 50, leading: 0, bottom: 10, trailing: 0))
            
            Button(action: {
                if isSubmitAnswer {
                    // MARK: - 임시
                    isSubmitAnswer.toggle()
                    selectedPage = 1
                } else if isSubmitAnswer == false && isLogin == true {
                    isShowingAnsweringView.toggle()
                } else if isSubmitAnswer == false && isLogin == false {
                    isShowingLoginAlert.toggle()
                }
            }, label: {
                AccentColorButtonView(title: isSubmitAnswer ? "내 답변 보러가기⌷" : "답변하기⌷")
            })
        }
        .padding()
        .background(Color.backGround)
        .onAppear {
            isLogin = loginViewModel.isSignedIn
        }
        
        .sheet(isPresented: $isShowingAnsweringView) {
            AnsweringView(question: $question, isSubmitAnswer: $isSubmitAnswer)
        }
        
        .alert("로그인 하시겠습니까?", isPresented: $isShowingLoginAlert) {
            Button(role: .cancel, action: { }, label: {
                Text("취소하기")
            })
            
            Button(action: {
                loginViewModel.loginGoogle {
                    isLogin = loginViewModel.isSignedIn
                }
            }, label: {
                Text("로그인 하기")
            })
        } message: {
            Text("질문에 답변하려면 로그인이 필요합니다.")
        }
    }
}

#Preview {
    QuestionView(selectedPage: .constant(0))
        .environmentObject(QuestionViewModel())
        .environmentObject(LoginViewModel())
        .preferredColorScheme(.dark)
}
