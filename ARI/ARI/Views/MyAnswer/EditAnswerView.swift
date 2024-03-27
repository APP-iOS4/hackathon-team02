//
//  EditAnswerView.swift
//  ARI
//
//  Created by 기 표 on 3/27/24.
//

import SwiftUI

struct EditAnswerView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var isShowingEditView: Bool
    @Binding var myAnswerExample: [String]
    var selectedAnswerIndex: Int
    
    @State private var editedAnswer: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("답변을 작성해주세요.", text: $editedAnswer)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            .onAppear {
                editedAnswer = myAnswerExample[selectedAnswerIndex]
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        isShowingEditView = false
                    }
                    .padding()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("수정") {
                        myAnswerExample[selectedAnswerIndex] = editedAnswer
                        isShowingEditView = false
                    }
                    .padding()
                }
            }
            .navigationTitle("최근 답변")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
    }
}

//#Preview {
//    EditAnswerView(editedAnswer: "", isShowingEditView: .constant(true), myAnswerExample: .constant(["Sample answer"]), selectedAnswerIndex: 0)
//}
