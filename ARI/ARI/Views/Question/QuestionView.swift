//
//  HomeView.swift
//  ARI
//
//  Created by Healthy on 3/27/24.
//

import SwiftUI

struct QuestionView: View {
    @State private var currentTime = Date()
    @State private var isShowingAnsweringView = false
    @State private var isShowingLoginAlert = false
    @State private var isLogin = false
    
    private var userNickname: String {
        if isLogin {
            return "User"
        } else {
            return "Unknown"
        }
    }
    
    @State var dummyQuestion = "struct와 class의 차이를 설명하시오."
    @AppStorage("isSubmitAnswer") var isSubmitAnswer: Bool = false
    
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
            
            // Firebase에서 문제 받아서와서 나타내기
            HStack {
                Rectangle()
                    .fill(Color.background2)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        Text("\(dummyQuestion)")
                            .font(.title)
                            .fontDesign(.monospaced)
                            .foregroundStyle(Color.accent)
                            .padding()
                            .minimumScaleFactor(0.5)
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
                    // MARK: - 탭 바꾸기
                    print("내 답변 탭으로 넘어가기")
                    // 임시
                    isSubmitAnswer.toggle()
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
        .sheet(isPresented: $isShowingAnsweringView) {
            AnsweringView(question: $dummyQuestion, isSubmitAnswer: $isSubmitAnswer)
        }
        
        .alert("로그인 하시겠습니까?", isPresented: $isShowingLoginAlert) {
            Button(role: .cancel, action: { }, label: {
                Text("취소하기")
            })
            
            Button(action: {
                // MARK: - 구글 로그인
                print("구글 로그인")
                isLogin.toggle()
            }, label: {
                Text("로그인 하기")
            })
        } message: {
            Text("질문에 답변하려면 로그인이 필요합니다.")
        }
    }
}

#Preview {
    QuestionView()
        .preferredColorScheme(.dark)
}
