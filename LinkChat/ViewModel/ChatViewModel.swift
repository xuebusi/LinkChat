//
//  ChatViewModel.swift
//  LinkChat
//
//  Created by link on 2023/3/30.
//

import Foundation

class ChatViewModel: ObservableObject {
    @Published var secretKey: String = UserDefManager.getString(key: Config.SECRET_KEY_NAME)
    @Published var messages: [Message] = [Message(role: .robot, content: "你好！有什么我可以帮助你的吗？", status: .complated)]
    @Published var showErrorBox: Bool = false
    @Published var errorMessage: String = ""
    
    private let api: OpenAIAPI
    @Published var messageText: String = ""
    
    init(api: OpenAIAPI) {
        self.api = api
    }
    
    @MainActor
    func retry(text: String) async {
        await send(text: text)
    }
    
    @MainActor
    private func send(text: String) async {
        self.messages.append(Message(role: .robot, content: "思考中...", status: .thinking))
        do {
            var context = ""
            if self.messages.count >= 2{
                context = self.messages[self.messages.count - 2].content
            }
            let stream = try await api.sendMessageStream(text: text, context: context)
            var responseText = ""
            for try await text in stream {
                responseText += text
                self.messages.removeLast()
                self.messages.append(Message(role: .robot, content: responseText, status: .sending))
            }
        } catch {
            self.messages.removeLast()
            self.messages.append(Message(role: .robot, content: "网络异常，请检查网络配置！", status: .error))
            return
        }
        let lastMessage = self.messages.last
        self.messages.removeLast()
        self.messages.append(Message(role: .robot, content: lastMessage?.content ?? "", status: .complated))
    }
}
