//
//  DevelopersDetailView.swift
//  ARI
//
//  Created by 이우석 on 3/27/24.
//

import SwiftUI

struct DevelopersDetailView: View {
    var userNickname: String
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                Text("""
                    \(userNickname) ~ % ari --developers
                    
                    
                          ###    #######   ####
                        ##   ##  ##    ##   ##
                       ########  #######    ##
                       ##    ##  ##   ##    ##
                       ##    ##  ##    ##  ####
                    
                    Apple developer Random Interview
                    iOS 개발자를 위한 랜덤 기술면접 질문 앱
                    
                    
                    만든 사람들
                    
                    강건
                    GitHub ID: kangsworkspace
                    
                    김기표
                    GitHub ID: rlvy0513
                    
                    김성민
                    GitHub ID: marukim365
                    
                    이우석
                    GitHub ID: wl00ie19
                    
                    
                    
                    \(userNickname) ~ % ari --packages
                    
                    
                    이 앱은 아래의 패키지를 사용합니다.
                    
                    Firebase
                    github.com/firebase/firebase-ios-sdk
                    
                    GoogleSignIn
                    github.com/google/GoogleSignIn-iOS
                    ⌷
                    """)
                
            }
            .font(.subheadline)
            .foregroundStyle(.text)
            .padding(15)
        }
        .fontDesign(.monospaced)
        .background(.backGround)
    }
}

#Preview {
    DevelopersDetailView(userNickname: "ARI")
        .preferredColorScheme(.dark)
}
