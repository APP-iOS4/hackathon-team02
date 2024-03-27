//
//  DataTestView.swift
//  ARI
//
//  Created by Healthy on 3/27/24.
//

import SwiftUI

struct DataTestView: View {
    @EnvironmentObject private var questionModel: QuestionViewModel
    
    @State var question: String = ""
    
    var body: some View {
        VStack {
            Text(question)
            
            Button {
                question = questionModel.getRandomQuestion().question
            } label: {
                Text("문제 가져오기 버튼")
            }
        }
    }
}

#Preview {
    DataTestView()
        .environmentObject(QuestionViewModel())
}
