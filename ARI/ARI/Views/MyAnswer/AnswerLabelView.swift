//
//  AnswerLabelView.swift
//  ARI
//
//  Created by 이우석 on 3/27/24.
//

import SwiftUI

struct AnswerLabelView: View {
    var number: Int
    var question: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .foregroundStyle(.background2)
            VStack(alignment: .leading) {
                HStack {
                    Text("#\(number)")
                        .foregroundStyle(.accent)
                        .fontWeight(.heavy)
                        .font(.title3)
                    Spacer()
                    Text("Date")
                        .foregroundStyle(.text)
                }
                Text("\(question)")
                    .foregroundStyle(.text)
                    .font(.title3)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
            }
            .padding(20)
        }
        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
    }
}

#Preview {
    AnswerLabelView(number: 0, question: "질문내용질문질문질문질문질문질문질문질문질문질문질문질문질문질문")
}
