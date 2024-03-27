//
//  QuestionViewModel.swift
//  ARI
//
//  Created by Healthy on 3/27/24.
//

import Foundation
import Observation

import FirebaseCore
import FirebaseFirestore


class QuestionViewModel: ObservableObject {
    private var questions: [QuestionData] = []
    
    init() {
        Task {
            await fetchQuestions()
            print("패치 완료")
        }
    }
    
    /// 파이어베이스에서 문제 데이터 가져오기
    private func loadQuestions() async {
        
        // MARK: - Firebase의 Cloud Firestore에서 읽기
        
        do {
            let dataBase = Firestore.firestore()
            let snapshots = try await dataBase.collection("Questions").getDocuments()
            
            var savedQuestions: [QuestionData] = []
            
            for document in snapshots.documents {
                let id: String = document.documentID
                
                let docData = document.data()
                let question: String = docData["question"] as? String ?? ""
                
                let newQuestion: QuestionData = QuestionData(id: id, question: question)
                
                print("\(newQuestion.question), \(newQuestion.id)")

                savedQuestions.append(newQuestion)
            }
            questions = savedQuestions
        } catch {
            print("Error getting documents: \(error)")
        }
    }
    
    /// 문제 데이터 fetch
    func fetchQuestions() async {
        await loadQuestions()
    }
    
    /// 랜덤으로 문제 하나를 가져오기
    /// - Returns: Question
    /// - Question 타입이기 때문에 .qustion과 .id를 사용해주세요
    func getRandomQuestion() -> QuestionData {
        return questions.randomElement() ?? QuestionData(id: "error", question: "저장된 질문이 없습니다.")
    }
}
