//
//  MyAnswer.swift
//  ARI
//
//  Created by Healthy on 3/27/24.
//

import SwiftUI

struct MyAnswerView: View {
    @EnvironmentObject private var questionModel: QuestionViewModel
    @EnvironmentObject private var loginViewModel: LoginViewModel
    
    @Namespace private var namespace
    @State private var isShowingRecent: Bool = true
    
    @State var recentQuestion: [QuestionData] = [.init(id: "123", question: "Example Recent Question")]
    @State var favoriteQuestion: [QuestionData] = [.init(id: "123", question: "Example Favorite Question")]
    
    @State var myAnswerDummy: [String] = ["답변입니다111111111","답변입니다222222222"]
    @State var otherAnswerDummy: [String] = ["답변입니다222222222", "답변입니다3333333", "답변입니다444444444"]
    @State private var isLogin: Bool = false
    
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if isLogin {
                    HStack {
                        ZStack(alignment: .center) {
                            Text("최근 답변")
                                .fontWeight(.bold)
                                .foregroundStyle(isShowingRecent ? .accent : .text )
                                .background{
                                    if isShowingRecent {
                                        Rectangle()
                                            .foregroundStyle(isShowingRecent ? .accent : .clear)
                                            .matchedGeometryEffect(id: "category", in: namespace)
                                            .frame(height: 2)
                                            .offset(y: 15)
                                    }
                                }
                                .padding(EdgeInsets(top: 5, leading: 20, bottom: 10, trailing: 20))
                        }
                        .onTapGesture {
                            withAnimation(.spring()) {
                                isShowingRecent = true
                            }
                            
                        }
                        
                        ZStack(alignment: .center) {
                            Text("즐겨찾기")
                                .fontWeight(.bold)
                                .foregroundStyle(!isShowingRecent ? .accent : .text )
                                .background{
                                    if !isShowingRecent {
                                        Rectangle()
                                            .foregroundStyle(!isShowingRecent ? .accent : .clear)
                                            .matchedGeometryEffect(id: "category", in: namespace)
                                            .frame(height: 2)
                                            .offset(y: 15)
                                    }
                                }
                                .padding(EdgeInsets(top: 5, leading: 20, bottom: 10, trailing: 20))
                        }
                        .onTapGesture {
                            withAnimation(.spring()) {
                                isShowingRecent = false
                            }
                        }
                    }
                    
                    ScrollView {
                        LazyVStack {
                            HStack {
                                Text("for question in \(isShowingRecent ? "recentAnswers" : "favorites") {")
                                    .font(.subheadline)
                                    .foregroundStyle(.accent)
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 15, leading: 10, bottom: 0, trailing: 10))
                            if isShowingRecent {
                                ForEach(recentQuestion.indices, id: \.self) { index in
                                    NavigationLink(destination: AnswerDetailView(answer: recentQuestion[index].question, selectedQuestionIndex: index, recentQuestion: recentQuestion.map{ $0.question }, myAnswerExample: $myAnswerDummy, otherAnswerExample: $otherAnswerDummy)) {
                                        AnswerLabelView(number: recentQuestion.count - index - 1, question: recentQuestion[index].question)
                                    }
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            recentQuestion.remove(at: index)
                                        } label: {
                                            Label("삭제", systemImage: "trash")
                                        }
                                    }
                                }
                            } else {
                                ForEach(favoriteQuestion.indices, id: \.self) { index in
                                    NavigationLink(destination: AnswerDetailView(answer: favoriteQuestion[index].question, selectedQuestionIndex: index, recentQuestion: favoriteQuestion.map{ $0.question }, myAnswerExample: $myAnswerDummy, otherAnswerExample: $otherAnswerDummy)) {
                                        AnswerLabelView(number: favoriteQuestion.count - index - 1, question: favoriteQuestion[index].question)
                                    }
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            favoriteQuestion.remove(at: index)
                                        } label: {
                                            Label("삭제", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                            HStack {
                                Text("}⌷")
                                    .font(.subheadline)
                                    .foregroundStyle(.accent)
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 15, trailing: 10))
                        }
                    }
                    .refreshable {
                        Task {
                            await questionModel.fetchQuestions()
                        }
                        
                        recentQuestion.insert(questionModel.getRandomQuestion(), at: 0)
                        print("Refresh")
                    }
                } else {
                    ZStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                                Text("Unknown ~ % my-answers\n")
                                Text("ERROR: Access denied.")
                                    .fontWeight(.bold)
                                Text("""
                                    
                                    
                                    로그아웃 상태입니다.
                                    로그인 버튼을 눌러 로그인을 해주세요.
                                    """)
                            Spacer()
                        }
                        .font(.subheadline)
                        .foregroundStyle(.text)
                        .padding()
                        
                        HStack {
                            Spacer()
                            
                            Button {
                                DispatchQueue.main.async {
                                    loginViewModel.loginGoogle {
                                        isLogin = loginViewModel.isSignedIn
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(">Login⌷")
                                        .font(.title.bold())
                                        .padding(10)
                                }
                            }
                            
                            Spacer()
                        }
                    }
                }
            }
            .fontDesign(.monospaced)
            .background(.backGround)
            .onAppear {
                isLogin = loginViewModel.isSignedIn
            }
        }
    }
}

#Preview {
    MyAnswerView()
        .preferredColorScheme(.dark)
        .environmentObject(LoginViewModel())
}
