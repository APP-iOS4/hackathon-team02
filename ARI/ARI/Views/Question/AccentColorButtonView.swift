//
//  AccentColorButtonView.swift
//  ARI
//
//  Created by 김성민 on 3/27/24.
//

import SwiftUI

struct AccentColorButtonView: View {
    let title: String
    var isActive: Bool = true
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(isActive ? Color.button : Color(UIColor.systemGray4))
                .frame(height: 54)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text("\(title)")
                .font(.title3).bold()
                .fontDesign(.monospaced)
                .foregroundStyle(isActive ? Color.text : Color(UIColor.systemGray3))
        }
        // .frame(maxWidth: .infinity)
    }
}

#Preview {
    AccentColorButtonView(title: "답변하기")
        .preferredColorScheme(.dark)
}
