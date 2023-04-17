//
//  ConfigFormView.swift
//  LinkChat
//
//  Created by link on 2023/4/3.
//

import SwiftUI

struct ConfigFormView: View {
    @State var showAlert: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    NavigationLink("密钥") {
                        ConfigApiKeyView(showSuccessBox: $showAlert)
                    }
                }
                
                Section {
                    NavigationLink("关于") {
                        AboutInfoView()
                    }
                }
            }
            .navigationTitle("配置")
            .navigationBarTitleDisplayMode(.inline)
            .overlay(
                showAlert ? AnyView(
                    SuccessAlertView(
                        isPresented: $showAlert,
                        message: "保存成功",
                        action: {
                            // 保存成功后的处理逻辑
                        }
                    ).zIndex(1) // 将AlertView覆盖在主视图上
                ) : AnyView(EmptyView())
            )
        }
        // 解决在iPad上视图被折叠问题
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ConfigFormView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigFormView()
    }
}
