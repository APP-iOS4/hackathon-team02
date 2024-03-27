//
//  AnswerDetailView.swift
//  ARI
//
//  Created by 기 표 on 3/27/24.
//

import SwiftUI

struct AnswerDetailView: View {
    @State private var questionHeight: CGFloat = .zero
    @Environment(\.dismiss) var dismiss
    @State private var isShowingEditView = false
    
    var answer: String
    
    @State var exampleRecent: [String] = []
    @Binding var myAnswerExample: [String]
    @Binding var otherAnswerExample: [String]
    @State var selectedQuestionIndex: Int = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Text("for question in questions {")
                            .foregroundStyle(.accent)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding(.vertical, 20)
                    
                    // MARK: - 질문
                    MyQuestionCell(exampleRecent: $exampleRecent, selectedQuestionIndex: selectedQuestionIndex)
                    
                    HStack {
                        Text("myAnswer()")
                            .foregroundStyle(.accent)
                            .fontWeight(.semibold)

                        Spacer()
                    }
                    
                    // MARK: - 내 답변
                    AnswerCell(answer: myAnswerExample.isEmpty ? "" : myAnswerExample[0])
                        .padding(.bottom, 30)
                    Spacer()
                    
                    HStack {
                        Text("otherAnswer()")
                            .foregroundStyle(.accent)
                            .fontWeight(.semibold)

                        Spacer()
                    }
                    
                    LazyVStack {
                        ForEach(otherAnswerExample.indices, id: \.self) { index in
                            AnswerCell(answer: otherAnswerExample[index])
                                .padding(.bottom)
                        }
                    }
                    HStack {
                        Text("}⌷")
                            .foregroundStyle(.accent)
                            .fontWeight(.semibold)

                        Spacer()
                    }
                    .padding(.vertical, 20)
                }
                .fontDesign(.monospaced)
                .toolbar(.hidden, for: .tabBar)
                .padding(10)
            }
            .padding(1)
            .fontDesign(.monospaced)
            .background(.backGround)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button(action: {
                        isShowingEditView.toggle()
                    }, label: {
                        Label("수정하기", systemImage: "square.and.pencil")
                    })
                    Button(role: .destructive) {
                        dismiss()
                    } label: {
                        Label("삭제하기", systemImage: "trash")
                    }
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15)
                        .rotationEffect(.degrees(90))
                        .foregroundStyle(.accent)
                }
            }
            
        }
        .navigationTitle("최근 답변")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingEditView) {
            EditAnswerView(isShowingEditView: $isShowingEditView)
        }
    }
}


//#Preview {
//    AnswerDetailView(answer: "답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다.", exampleRecent: .constant(["Question 1", "Question 2"]), myAnswerExample: .constant(["My Answer"]), otherAnswerExample: .constant(["Other Answer 1", "Other Answer 2"]), selectedQuestionIndex: 0)
//        .preferredColorScheme(.dark)
//}
