//
//  Question.swift
//  ARI
//
//  Created by Healthy on 3/27/24.
//

import Foundation

/// 문제
/// - Parameter id: 질문 식별을 위한 id값
/// - Parameter question: 질문 내용
struct QuestionData: Identifiable {
    var id: String
    var question: String
}
