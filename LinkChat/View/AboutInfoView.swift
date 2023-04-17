//
//  AboutInfoView.swift
//  LinkChat
//
//  Created by link on 2023/4/6.
//

import SwiftUI

struct AboutInfoView: View {
    var body: some View {
        List {
            Section {
                HStack {
                    Text("邮箱")
                    Spacer()
                    Text("xuebusi@foxmail.com")
                        .accentColor(.primary)
                }
                HStack {
                    Text("公众号")
                    Spacer()
                    Text("SwiftUI训练营")
                }
            } header: {
                Text("联系方式")
            }
            
            Section {
                Image("wechat")
                    .resizable()
                    .scaledToFit()
            } header: {
                Text("我的微信")
            } footer: {
                Text("加我微信进群一起学习交流SwiftUI技术")
            }
        }
        .navigationTitle("关于")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AboutInfoView()
    }
}
