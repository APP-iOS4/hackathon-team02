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
    
    @State var question: String = ""
    @State var isLogin: Bool = false
    
    var body: some View {
        VStack(spacing: 30) {
            Text(question)
            
            Text("\(isLogin)")
            
            Button {
                question = questionModel.getRandomQuestion().question
            } label: {
                Text("문제 가져오기 버튼")
            }
            
            Button {
                loginViewModel.loginGoogle {
                    isLogin = loginViewModel.isSignedIn
                }
            } label: {
                Text("로그인 버튼")
            }
            
            Button {
                loginViewModel.logoutGoogle {
                    isLogin = loginViewModel.isSignedIn
                }
            } label: {
                Text("로그아웃 버튼")
            }
        }
    }
}

#Preview {
    DataTestView()
        .environmentObject(QuestionViewModel())
        .environmentObject(LoginViewModel())
}
