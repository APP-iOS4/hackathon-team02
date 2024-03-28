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
    var answeredQuestions: [QuestionData] = []
    
    init() {
        Task {
            await fetchQuestions()
        }
    }
    
    /// 파이어베이스에서 문제 데이터 가져오기
    private func loadQuestions() async {
        do {
            let dataBase = Firestore.firestore()
            let snapshots = try await dataBase.collection("Questions").getDocuments()
            
            var savedQuestions: [QuestionData] = []
            
            for document in snapshots.documents {
                // id = 문제 id값
                let id: String = document.documentID
                
                // question = 문제 내용
                let docData = document.data()
                let question: String = docData["question"] as? String ?? ""
                
                // 문제 인스턴스 생성 후 savedQuestions에 저장
                let newQuestion: QuestionData = QuestionData(id: id, question: question)
                savedQuestions.append(newQuestion)
            }
            
            // 파이어 베이스에서 받아온 데이터 할당
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
    
    
    
    /// 내 답을 추가하는 함수
    /// - Parameters answer: 답 내용
    /// - Parameters userID: 유저 ID값(Email이 아닌 id값을 넣어주셔야 합니다.)
    /// - Parameters questionID: 문제 ID값
    func addAnswer(answer: String, userID: String, questionID: String) {
        // Firebase의 Cloud Firestore에 새로운 답변 추가
        Task {
            do {
                let dataBase = Firestore.firestore()
                try await dataBase.collection("Questions").document(questionID).collection("Answer").document(userID).setData([
                    "answer": answer
                ])
            } catch {
                print("Error writing document: \(error)")
            }
        }
    }
    
    /// 나의 답을 리턴하는 함수
    /// 답변을 하지 않았을 때 ""를 리턴한다.
    func loadMyAnswer(questionID: String, userID: String) async -> String {
        var myAnswer: String = ""
        
        do {
            let dataBase = Firestore.firestore()
            let snapshots = try await dataBase.collection("Questions").document(questionID).collection("Answer").getDocuments()
            for doc in snapshots.documents {
                if doc.documentID == userID {
                    myAnswer = doc["answer"] as? String ?? ""
                }
            }
        } catch {
            print("Error getting documents: \(error)")
        }
        return myAnswer
    }
    
    /// (나의 답을 제외한)모든 답을 리턴하는 함수
    func loadOthersAnswer(questionID: String, userID: String) async -> [String] {
        var othersAnswer: [String] = []
        
        do {
            let dataBase = Firestore.firestore()
            let snapshots = try await dataBase.collection("Questions").document(questionID).collection("Answer").getDocuments()
            
            print(snapshots.count)
            
            for doc in snapshots.documents {
                if doc.documentID != userID {
                    othersAnswer.append(doc["answer"] as? String ?? "")
                }
            }
        } catch {
            print("Error getting documents: \(error)")
        }
        
        print("\(othersAnswer)")
        
        return othersAnswer
    }
    
    func loadMyAnsweredQuestion() {
        var myAnsweredQuestion: [QuestionData] = []
        
        
    }
}
