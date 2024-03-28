//
//  LoginViewModel.swift
//  ARI
//
//  Created by Healthy on 3/27/24.
//

import SwiftUI
import Observation

import FirebaseCore
// 이메일 비밀번호 -> 로그인(파이어 베이스 인증 & 구글 로그인)
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import GoogleSignInSwift

class LoginViewModel: ObservableObject {
    /// 유저 데이터 정보
    var userInfo: User?
    
    /// 현재 로그인 된 정보가 있는가를 리턴하는 함수
    var isSignedIn: Bool {
        return UserDefaults.standard.string(forKey: "userID") == nil ? false : true
    }
    
    /// 구글 로그인 실행
    func loginGoogle(completion: @escaping () -> Void) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController
        else { return }
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            guard error == nil else {
                // ...
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                // ...
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            // ...
            
            Auth.auth().signIn(with: credential) { result, error in
                // At this point, our user is signed in
                guard let result else { return }
                print("\(String(describing: result.user.uid)), \(String(describing: result.user.email))")
                
                let user = User(id: result.user.uid, email: result.user.email ?? "이메일 정보 없음")
                // 현재 유저 정보 저장
                self.saveUserDataToUserDefaults(User: user)
                self.fetchUserInfo()

                print("유저 디폴트 \(UserDefaults.standard.string(forKey: "userID"))")
                print("유저 디폴트 \(UserDefaults.standard.string(forKey: "userEmail"))")
                      
                completion()
            }
        }
    }
    
    /// 구글 로그아웃 실행
    func logoutGoogle(completion: @escaping () -> Void) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            // 현재 유저 정보 삭제
            // self.userInfo = nil
            deleteUserDataFromUserDefaults()
            self.fetchUserInfo()
            completion()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    /// UserDefaults에 유저 데이터 저장
    private func saveUserDataToUserDefaults(User: User) {
        UserDefaults.standard.setValue(User.id, forKey: "userID")
        UserDefaults.standard.setValue(User.email, forKey: "userEmail")
    }
    
    /// UserDefaults에서 유저 데이터 삭제
    private func deleteUserDataFromUserDefaults() {
        UserDefaults.standard.removeObject(forKey: "userID")
        UserDefaults.standard.removeObject(forKey: "userEmail")
    }
    
    /// UserDefaults의 데이터 userInfo에 저장
    func fetchUserInfo() {
        if let userID = UserDefaults.standard.string(forKey: "userID"), let userEmail = UserDefaults.standard.string(forKey: "userEmail") {
            userInfo = User(id: userID, email: userEmail)
        }
    }
}

