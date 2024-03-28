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
    @Binding var recentQuestion: QuestionData
    @State private var editedAnswer: String = ""
    @State private var editHeight: CGFloat = .zero

    var selectedAnswerIndex: Int
    var placeholder = "답변을 입력해주세요."

    var body: some View {
        NavigationView {
            VStack {
                Text("\(recentQuestion)")
                    .fontDesign(.monospaced)
                    .foregroundStyle(Color.accent)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding([.top, .leading, .trailing])
                
                    VStack {
                        TextEditor(text: $editedAnswer)
                            .foregroundStyle(editedAnswer == placeholder ? .gray : .text)
                            .scrollContentBackground(.hidden)
                            .background(Color.background2)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .fontDesign(.monospaced)
                            .padding()
                            .foregroundColor(.white)
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
}
//#Preview {
//    EditAnswerView(editedAnswer: "", isShowingEditView: .constant(true), myAnswerExample: .constant(["Sample answer"]), selectedAnswerIndex: 0)
//}
