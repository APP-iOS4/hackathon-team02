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
    
    @StateObject private var questionUserDefaultsClient = QuestionUserDefaultsClient()
    
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

    @State private var remainingHours = 0
    @State private var remainingMinutes = 0
    @State private var remainingSeconds = 0
    
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
                    Text("~ % question --today")
                }
                
                Text("Remaining time: \(remainingHours):\(remainingMinutes):\(remainingSeconds)")
                    .onReceive(timer) { _ in
                        self.calculateRemainingTime()
                    }
                    .onAppear {
                        self.calculateRemainingTime()
                    }
                    .fontDesign(.monospaced)
                    .foregroundStyle(Color.accent)
                    .font(.subheadline)
                    .padding(.top, 30)
                    
            }
            .fontDesign(.monospaced)
            .foregroundStyle(Color.accent)
            .font(.subheadline)
            
            Spacer()
            
            HStack {
                Rectangle()
                    .fill(Color.background2)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        if !questionUserDefaultsClient.isCheckingQuestion {
                            Text("오늘의 질문을 확인해주세요.")
                                .padding()
                                .multilineTextAlignment(.center)
                        } else {
                            Text("\(questionUserDefaultsClient.question)")
                                .padding()
                                .multilineTextAlignment(.center)
                        }
                        
                    }
                    .font(.title)
                    .fontWeight(.semibold)
                    .fontDesign(.monospaced)
                    .foregroundStyle(Color.accent)
                    .minimumScaleFactor(0.5)
            }
            
            // Test
            /*
            Button {
                questionUserDefaultsClient.isCheckingQuestion.toggle()
            } label: {
                Text("test")
            }
            */
            
            HStack {
                if questionUserDefaultsClient.isSubmitAnswer {
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
                if !questionUserDefaultsClient.isCheckingQuestion {
                    Task {
                        await saveTime()
                    }
                    
                    questionUserDefaultsClient.question = questionModel.getRandomQuestion().question
                    questionUserDefaultsClient.questionID = questionModel.getRandomQuestion().id
                    questionUserDefaultsClient.isCheckingQuestion.toggle()
                } else if questionUserDefaultsClient.isSubmitAnswer {
                    // MARK: - 임시
                    // questionUserDefaultsClient.isSubmitAnswer.toggle()
                    selectedPage = 1
                } else if questionUserDefaultsClient.isSubmitAnswer == false && isLogin == true {
                    isShowingAnsweringView.toggle()
                } else if questionUserDefaultsClient.isSubmitAnswer == false && isLogin == false {
                    isShowingLoginAlert.toggle()
                }
            }, label: {
                if !questionUserDefaultsClient.isCheckingQuestion {
                    AccentColorButtonView(title: "질문 확인하기⌷")
                } else {
                    AccentColorButtonView(title: questionUserDefaultsClient.isSubmitAnswer ? "내 답변 보러가기⌷" : "답변하기⌷")
                }
            })
        }
        .padding()
        .background(Color.backGround)
        .onAppear {
            isLogin = loginViewModel.isSignedIn
            
            checkTime()
        }
        
        .sheet(isPresented: $isShowingAnsweringView) {
            AnsweringView(question: $questionUserDefaultsClient.question,
                          questionID: $questionUserDefaultsClient.questionID,
                          isSubmitAnswer: $questionUserDefaultsClient.isSubmitAnswer)
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

extension QuestionView {
    func saveTime() async {
        let koreaTimeZone = TimeZone(identifier: "Asia/Seoul")!
        var nowInKorea = Date()

        if let koreaDate = Calendar.current.date(byAdding: .second, value: koreaTimeZone.secondsFromGMT(), to: nowInKorea) {
            nowInKorea = koreaDate
        }
        
        UserDefaults.standard.set(nowInKorea, forKey: "savedTime")
        
        if let savedTime = UserDefaults.standard.object(forKey: "savedTime") as? Date {
            print("저장된 시각: \(savedTime)")
        }
        print("시간이 저장되었습니다.")
    }
    
    func checkTime() {
        if let savedTime = UserDefaults.standard.object(forKey: "savedTime") as? Date {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
            formatter.dateStyle = .medium
            
            let savedTimeString = formatter.string(from: savedTime)
            // 테스트를 하고 싶다면 Date() 뒤에다가 초를 더해주자.
            let currentTime = formatter.string(from: Date())

            let isRandomQuestion = (savedTimeString == currentTime)
            
            if isRandomQuestion {
                print("문제를 유지합니다.")
            } else {
                let question = questionModel.getRandomQuestion()
                
                questionUserDefaultsClient.question = question.question
                questionUserDefaultsClient.questionID = question.id
                questionUserDefaultsClient.isCheckingQuestion = false
                questionUserDefaultsClient.isSubmitAnswer = false
                
                print("문제가 변경되었습니다.")
            }
        }
    }
    
    func calculateRemainingTime() {
           let now = Date()
           let calendar = Calendar.current
           let midnight = calendar.startOfDay(for: now).addingTimeInterval(24 * 60 * 60)
           
           let components = calendar.dateComponents([.hour, .minute, .second], from: now, to: midnight)
           remainingHours = components.hour ?? 0
           remainingMinutes = components.minute ?? 0
           remainingSeconds = components.second ?? 0
       }
}
