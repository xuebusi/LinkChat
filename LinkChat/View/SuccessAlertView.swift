//
//  SuccessAlertView.swift
//  LinkChat
//
//  Created by link on 2023/4/4.
//

import SwiftUI

struct SuccessAlertView: View {
    @Binding var isPresented: Bool
    let message: String
    let action: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            Text(message)
                .font(.system(.headline))
        }
        .padding()
        .frame(width: 130, height: 130)
        .foregroundColor(.white)
        .background(.black.opacity(0.6))
        .cornerRadius(10)
        .onAppear {
            // 自动消失
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    isPresented = false
                }
            }
        }
    }
}

struct SuccessAlertView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessAlertView(isPresented: Binding.constant(false), message: "复制成功", action: {
            print(">>> 复制成功")
        })
    }
}
