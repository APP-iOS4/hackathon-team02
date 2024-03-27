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
                loginViewModel.loginGoogle()
            } label: {
                Text("로그인 버튼")
            }
            
            Button {
                loginViewModel.logoutGoogle()
            } label: {
                Text("로그아웃 버튼")
            }
            
            Button {
                isLogin = checkIsUserLogin()
            } label: {
                Text("로그인 확인 버튼")
            }
        }
    }
    
    func checkIsUserLogin() -> Bool {
        return loginViewModel.isUserLogin()
    }
}

#Preview {
    DataTestView()
        .environmentObject(QuestionViewModel())
        .environmentObject(LoginViewModel())
}
