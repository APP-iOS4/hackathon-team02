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
    var userInfo: User?
    
    /// 현재 로그인 된 정보가 있는가?
    var isSignedIn: Bool {
        return userInfo == nil ? false : true
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
                // 현재 유저 정보 저장
                self.userInfo = User(id: result.user.uid, email: result.user.email ?? "이메일 정보 없음")
                
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
            self.userInfo = nil

            completion()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

//enum AuthenticationState {
//    case unauthenticated
//    case authenticating
//    case authenticated
//}
//
//enum AuthenticationFlow {
//    case login
//    case signUp
//}
//
//@MainActor
//class AuthenticationStore: ObservableObject {
//    @Published var name: String = "unkown"
//
//    @Published var email: String = ""
//    @Published var password: String = ""
//    @Published var confirmPassword: String = ""
//
//    @Published var flow: AuthenticationFlow = .login
//
//    @Published var isValid: Bool  = false
//    @Published var authenticationState: AuthenticationState = .unauthenticated
//    @Published var errorMessage: String = ""
//    @Published var user: User?
//    @Published var displayName: String = ""
//
//    init() {
//        registerAuthStateHandler()
//
//        $flow
//            .combineLatest($email, $password, $confirmPassword)
//            .map { flow, email, password, confirmPassword in
//                flow == .login
//                ? !(email.isEmpty || password.isEmpty)
//                : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
//            }
//            .assign(to: &$isValid)
//    }
//
//    private var authStateHandler: AuthStateDidChangeListenerHandle?
//
//    func registerAuthStateHandler() {
//        if authStateHandler == nil {
//            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
//                self.user = user
//                self.authenticationState = user == nil ? .unauthenticated : .authenticated
//                self.displayName = user?.email ?? ""
//            }
//        }
//    }
//
//    func switchFlow() {
//        flow = flow == .login ? .signUp : .login
//        errorMessage = ""
//    }
//
//    private func wait() async {
//        do {
//            print("Wait")
//            try await Task.sleep(nanoseconds: 1_000_000_000)
//            print("Done")
//        }
//        catch { }
//    }
//
//    func reset() {
//        flow = .login
//        email = ""
//        password = ""
//        confirmPassword = ""
//    }
//}
//
//extension AuthenticationStore {
//    func signInWithEmailPassword() async -> Bool {
//        authenticationState = .authenticating
//        do {
//            try await Auth.auth().signIn(withEmail: self.email, password: self.password)
//            return true
//        }
//        catch  {
//            print(error)
//            errorMessage = error.localizedDescription
//            authenticationState = .unauthenticated
//            return false
//        }
//    }
//
//    func signUpWithEmailPassword() async -> Bool {
//        authenticationState = .authenticating
//        do  {
//            try await Auth.auth().createUser(withEmail: email, password: password)
//            return true
//        }
//        catch {
//            print(error)
//            errorMessage = error.localizedDescription
//            authenticationState = .unauthenticated
//            return false
//        }
//    }
//
//    func signOut() {
//        do {
//            try Auth.auth().signOut()
//        }
//        catch {
//            print(error)
//            errorMessage = error.localizedDescription
//        }
//    }
//
//    func deleteAccount() async -> Bool {
//        do {
//            try await user?.delete()
//            return true
//        }
//        catch {
//            errorMessage = error.localizedDescription
//            return false
//        }
//    }
//}
//
//enum AuthenticationError: Error {
//    case tokenError(message: String)
//}
//
//extension AuthenticationStore {
//    func signInWithGoogle() async -> Bool {
//        guard let clientID = FirebaseApp.app()?.options.clientID else {
//            fatalError("No client ID found in Firebase configuration")
//        }
//        let config = GIDConfiguration(clientID: clientID)
//        GIDSignIn.sharedInstance.configuration = config
//
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//              let window = windowScene.windows.first,
//              let rootViewController = window.rootViewController else {
//            print("There is no root view controller!")
//            return false
//        }
//
//        do {
//            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
//
//            let user = userAuthentication.user
//            guard let idToken = user.idToken else { throw AuthenticationError.tokenError(message: "ID token missing") }
//            let accessToken = user.accessToken
//
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
//                                                           accessToken: accessToken.tokenString)
//
//            let result = try await Auth.auth().signIn(with: credential)
//            let firebaseUser = result.user
//            print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
//            return true
//        }
//        catch {
//            print(error.localizedDescription)
//            self.errorMessage = error.localizedDescription
//            return false
//        }
//    }
//}

