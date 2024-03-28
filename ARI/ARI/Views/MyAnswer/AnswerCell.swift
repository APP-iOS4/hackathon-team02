//
//  AnswerCell.swift
//  ARI
//
//  Created by 기 표 on 3/27/24.
//

import SwiftUI

struct AnswerCell: View {
    
    var answer: String
    
    @State private var answerHeight: CGFloat = .zero
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .foregroundStyle(.background2)
                .frame(height: answerHeight + 50)
            
            //MARK: - 문제
            
            VStack {
                HStack {
                    Text("\(answer)")
                        .background(
                            GeometryReader { geometry in
                                Color.clear.onAppear {
                                    answerHeight = geometry.size.height
                                }
                            }
                        )
                    Spacer()
                }
                .padding(.leading)
            }
            
            .foregroundStyle(.white)
            Spacer()
        }
    }
}

//#Preview {
//    AnswerCell(answer: "답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다. 답변입니다.")
//}
