//
//  MyquestionCell.swift
//  ARI
//
//  Created by 기 표 on 3/27/24.
//

import SwiftUI

struct MyQuestionCell: View {
    
    @State private var questionHeight: CGFloat = .zero
    
    @Binding var recentQuestion: [String]

    var selectedQuestionIndex: Int
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .foregroundStyle(.background2)
                .frame(height: questionHeight + 55)
            
            //MARK: - 문제
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("#\(selectedQuestionIndex)")
                        .foregroundStyle(.accent)
                        
                    Text("\(recentQuestion[selectedQuestionIndex])")
                        .background(
                            GeometryReader { geometry in
                                Color.clear.onAppear {
                                    questionHeight = geometry.size.height
                                }
                            }
                        )
                        .foregroundStyle(.white)
                }
                Spacer()
            }
            .padding(.horizontal, 25)
        }
        .padding(.bottom, 40)
    }
}

#Preview {
    MyQuestionCell(recentQuestion: .constant(["Question 1", "Question 2"]), selectedQuestionIndex: 0)
}
