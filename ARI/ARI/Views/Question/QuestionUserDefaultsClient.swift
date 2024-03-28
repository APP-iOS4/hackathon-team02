//
//  QuestionUserDefaultsClient.swift
//  ARI
//
//  Created by 김성민 on 3/28/24.
//

import Foundation

final class QuestionUserDefaultsClient: ObservableObject {
    @Published var isSubmitAnswer: Bool = UserDefaults.standard.bool(forKey: Key.isSubmitAnswer.rawValue) {
        didSet {
            UserDefaults.standard.set(isSubmitAnswer, forKey: Key.isSubmitAnswer.rawValue)
        }
    }
    
    @Published var question: String = (UserDefaults.standard.string(forKey: Key.question.rawValue) ?? "저장된 질문이 없습니다.") {
        didSet {
            UserDefaults.standard.set(question, forKey: Key.question.rawValue)
        }
    }
    
    @Published var isCheckingQuestion: Bool = UserDefaults.standard.bool(forKey: Key.isCheckingQuestion.rawValue) {
        didSet {
            UserDefaults.standard.set(isCheckingQuestion, forKey: Key.isCheckingQuestion.rawValue)
        }
    }
    
    @Published var questionID: String = UserDefaults.standard.string(forKey: Key.questionID.rawValue) ?? "errorID" {
        didSet {
            UserDefaults.standard.set(questionID, forKey: Key.questionID.rawValue)
        }
    }
    
    enum Key: String {
        case isSubmitAnswer
        case question
        case isCheckingQuestion
        case questionID
    }
}
