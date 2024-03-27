//
//  AnsweringView.swift
//  ARI
//
//  Created by 김성민 on 3/27/24.
//

import SwiftUI

struct AnsweringView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var answering = "답변을 입력해주세요."
    @State private var isShowingAlert = false
    
    @Binding var question: String
    @Binding var isSubmitAnswer: Bool
    
    var placeholder = "답변을 입력해주세요."
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("\(question)")
                    .fontDesign(.monospaced)
                    .foregroundStyle(Color.accent)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding([.top, .leading, .trailing])
                
                TextEditor(text: $answering)
                    .foregroundStyle(answering == placeholder ? .gray : .text)
                    .scrollContentBackground(.hidden)
                    .background(Color.background2)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                    .fontDesign(.monospaced)
                    .onAppear {
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
                            withAnimation {
                                if answering == placeholder {
                                    answering = ""
                                }
                            }
                        }
                        
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                            withAnimation {
                                if answering == "" {
                                    answering = placeholder
                                }
                            }
                        }
                    }
                
                Button(action: {
                    isSubmitAnswer.toggle()
                    dismiss()
                }, label: {
                    AccentColorButtonView(title: "답변 등록하기", 
                                          isActive: answering == placeholder || answering.isEmpty ? false : true)
                })
                .disabled(answering == placeholder || answering.isEmpty)
                .padding([.leading, .trailing, .bottom])
            }
            .background(Color.backGround)
            .navigationTitle("답변 작성하기")
            .toolbarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        if answering == placeholder {
                            dismiss()
                        } else if answering.isEmpty {
                            dismiss()
                        } else {
                            isShowingAlert.toggle()
                        }
                    }, label: {
                        Label("창 닫기", systemImage: "xmark.circle")
                    })
                }
            }
            
            .alert("창을 닫으시겠습니까?", isPresented: $isShowingAlert) {
                Button(role: .cancel, action: { }, label: {
                    Text("취소하기")
                })
                
                Button(action: {
                    dismiss()
                }, label: {
                    Text("닫기")
                })
            } message: {
                Text("작성한 답변이 모두 초기화됩니다.")
            }
        }
    }
}

#Preview {
    AnsweringView(question: .constant("struct와 class의 차이를 설명하시오."), isSubmitAnswer: .constant(false))
        .preferredColorScheme(.dark)
}
