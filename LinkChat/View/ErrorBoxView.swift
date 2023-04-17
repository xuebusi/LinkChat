//
//  ErrorBoxView.swift
//  LinkChat
//
//  Created by link on 2023/3/31.
//

import SwiftUI

struct ErrorBoxView: View {
    @Binding var showTipBox: Bool
    @State var color: Color
    @State var deadlineSecond: Double
    let message: String

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "exclamationmark.circle.fill")
            Text(message)
            Spacer()
            Button {
                self.showTipBox = false
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.secondary)
                    .frame(width: 25, height: 25)
            }
        }
        .padding()
        .foregroundColor(color)
        .frame(maxWidth: .infinity)
        .background(color.opacity(0.1))
        .opacity(showTipBox ? 1 : 0)
        .animation(.easeInOut(duration: 0.3), value: showTipBox)
        .onAppear {
            // 3秒后自动消失
            DispatchQueue.main.asyncAfter(deadline: .now() + deadlineSecond) {
                withAnimation {
                    showTipBox = false
                }
            }
        }
    }
}

struct ErrorBoxView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorBoxView(showTipBox: Binding.constant(true), color: .red, deadlineSecond: 5, message: "测试错误提示！")
    }
}
