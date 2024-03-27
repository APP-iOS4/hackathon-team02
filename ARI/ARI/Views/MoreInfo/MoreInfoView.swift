//
//  TempView.swift
//  ARI
//
//  Created by Healthy on 3/27/24.
//

import SwiftUI

struct MoreInfoView: View {
    @State private var isLogin: Bool = false
    @State private var isShowingAlert: Bool = false
    @State private var emailAddress: String = "abcd@example.com"
    
    @EnvironmentObject private var loginViewModel: LoginViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                            .foregroundStyle(.background2)
                        HStack {
                            VStack(alignment: .leading) {
                                Text("ARI ~ % userinfo")
                                Text(isLogin ? "\(emailAddress)" : "로그아웃 상태입니다")
                                
                            }
                            .foregroundStyle(.text)
                            
                            Spacer()
                            
                            if isLogin {
                                Button {
                                    DispatchQueue.main.async {
                                        isShowingAlert.toggle()
                                    }
                                    isLogin = loginViewModel.isUserLogin()
                                } label: {
                                    Text("Logout")
                                        .font(.title3.bold())
                                }
                            } else {
                                Button {
                                    DispatchQueue.main.async {
                                        Task{
                                            loginViewModel.loginGoogle()
                                        }
                                        isLogin = loginViewModel.isUserLogin()
                                        emailAddress = loginViewModel.userInfo?.email ?? ""
                                    }
                                } label: {
                                    Text("Login")
                                        .font(.title3.bold())
                                }
                            }
                        }
                        .padding()
                    }
                    .onChange(of: loginViewModel.isUserLogin()) {
                        isLogin = loginViewModel.isUserLogin()
                        // print("\(loginViewModel.userInfo?.email ?? "NO DATA")")
                    }
                    
                    
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                            .foregroundStyle(.background2)
                        VStack(alignment: .leading) {
                            Text("ARI ~ % ari --version")
                            Text("ARI")
                            Text("(Apple developer Random Interview)")
                                .font(.subheadline)
                            Text("Version 0.0.9")
                        }
                        .foregroundStyle(.text)
                        .padding()
                    }
                    
                    NavigationLink {
                        Text("개인정보처리방침 뷰 연결")
                    } label: {
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                .foregroundStyle(.background2)
                            VStack(alignment: .leading) {
                                Text("ARI ~ % ari --privacy-policy")
                            }
                            .padding()
                        }
                    }
                    
                    NavigationLink {
                        Text("크레딧 및 연락처 뷰 연결")
                    } label: {
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                .foregroundStyle(.background2)
                            VStack(alignment: .leading) {
                                Text("ARI ~ % ari --developers")
                            }
                            .padding()
                        }
                    }
                    
                }
            }
            .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
            .alert("로그아웃", isPresented: $isShowingAlert) {
                Button("로그아웃", role: .destructive) {
                    loginViewModel.logoutGoogle()
                    isLogin = loginViewModel.isUserLogin()
                    emailAddress = ""
                }
            } message: {
                Text("로그아웃 하시겠습니까?")
            }
            .fontDesign(.monospaced)
            .background(.backGround)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("더 보기")
                        .fontWeight(.bold)
                }
            }
        }
    }
}

#Preview {
    MoreInfoView()
        .preferredColorScheme(.dark)
}
