//
//  LoginState.swift
//  ARI
//
//  Created by Healthy on 3/27/24.
//

import Foundation

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum AuthenticationFlow {
    case login
    case signUp
}
