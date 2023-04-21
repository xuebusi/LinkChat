//
//  MessageView.swift
//  LinkChat
//
//  Created by link on 2023/3/30.
//

import SwiftUI

struct MessageView: View {
    @State var message: Message
    
    var body: some View {
        HStack {
            // 如果不是自己，则靠右对齐
            if !message.role.isMe {
                Spacer()
            }
            VStack(alignment: message.role.isMe ? .leading : .trailing, spacing: 5) {
                HStack(alignment: .center, spacing: 8) {
                    if message.role.isMe {
                        Image(message.role.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                        Text(message.role.name)
                            .font(.system(.headline))
                            .foregroundColor(.gray)
                    } else {
                        Text(message.role.name)
                            .font(.system(.headline))
                            .foregroundColor(.gray)
                        Image(message.role.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                    }
                }
                HStack {
                    if message.role.isMe {
                        Text(message.content)
                    } else {
                        if message.status == .thinking {
                            HStack(spacing: 10) {
                                Text("思考中...")
                                ProgressView()
                            }
                        } else if message.status == .error {
                            HStack(spacing: 10) {
                                Text("网络请求失败！请检查网络设置...")
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        } else {
                            Text(message.content)
                        }
                    }
                }
                .padding()
                .foregroundColor(.primary)
                .background(message.role.isMe ? .gray.opacity(0.1) : .cyan.opacity(0.5))
                .cornerRadius(10)
                .contextMenu() {
                    // 长按复制
                    HStack {
                        Button {
                            let pastebord = UIPasteboard.general
                            pastebord.string = message.content
                        } label: {
                            Text("拷贝")
                            Image(systemName: "doc.on.doc")
                        }
                    }
                }
                
            }
            // 如果是自己，则靠左对齐
            if message.role.isMe {
                Spacer()
            }
        }
        .id(message.id)
        .padding(.bottom, message.role.isMe ? 20 : 50)
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(
            message: Message(role: .robot, content: "思考中...", status: .thinking)
        )
    }
}
