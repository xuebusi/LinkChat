//
//  ChatWindowView.swift
//  LinkChat
//
//  Created by link on 2023/3/30.
//

import SwiftUI

struct ChatWindowView: View {
    @EnvironmentObject var vm: ChatViewModel
    @State var inputText: String = ""
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            messageListView
                .navigationTitle("聊天")
                .navigationBarTitleDisplayMode(.inline)
        }
        // 解决在iPad上视图被折叠问题
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var messageListView: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(vm.messages, id: \.id) { message in
                            MessageView(message: message)
                        }
                        .onAppear {
                            if ((vm.messages.last?.id) != nil) {
                                withAnimation {
                                    proxy.scrollTo(vm.messages.last?.id, anchor: .bottom)
                                }
                            }
                        }
                        .onChange(of: vm.messages) { (value) in
                            withAnimation {
                                proxy.scrollTo(value.last?.id, anchor: .bottom)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .gesture(
                    DragGesture()
                        .onChanged({ gesture in
                            let dragType = detectDrag(end: gesture.predictedEndLocation, start: gesture.location)
                            if dragType == .TopToBottom || dragType == .BottomToTop {
                                isTextFieldFocused = false
                            }
                        })
                )
                .onTapGesture {
                    isTextFieldFocused = false
                }
                
                // 错误提示框
                if vm.showErrorBox {
                    ErrorBoxView(showTipBox: $vm.showErrorBox, color: .red, deadlineSecond: 3, message: vm.errorMessage)
                }
                
                Divider()
                
                // 消息输入框
                HStack {
                    TextField("请在这里输入您的问题", text: $inputText, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($isTextFieldFocused)
                        .onTapGesture {
                            withAnimation {
                                proxy.scrollTo(vm.messages.last?.id, anchor: .bottom)
                            }
                        }
                    Button {
                        if inputText.isEmpty {
                            return
                        }
                        
                        print(">>>> inputText:\(inputText)")
                        
                        let secretKey = UserDefManager.getString(key: Config.SECRET_KEY_NAME)
                        vm.secretKey = secretKey.trimmingCharacters(in: .whitespacesAndNewlines)
                        if vm.secretKey.isEmpty {
                            vm.errorMessage = "请先配置API密钥!"
                            vm.showErrorBox = true
                            return
                        }
                        vm.messageText = ""
                        vm.messages.append(Message(role: .me, content: inputText, status: .complated))
                        let inputMessage = inputText
                        inputText = ""
                        Task { @MainActor in
                            await vm.retry(text: inputMessage)
                        }
                    } label: {
                        Image(systemName: "paperplane.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 30)
                            .foregroundColor(.cyan)
                    }
                }
                .padding(10)
                .background(.gray.opacity(0.1))
                Spacer()
            }
        }
    }
}

func detectDrag(end: CGPoint, start: CGPoint) -> DragGestureType {
    let horizontalMovement = end.x - start.x
    let verticalMovement = end.y - start.y
    
    if abs(horizontalMovement) > abs(verticalMovement) {
        if horizontalMovement > 0 {
            return .LeftToRight
        } else {
            return .RightToLeft
        }
    } else {
        if verticalMovement > 0 {
            return .TopToBottom
        } else {
            return .BottomToTop
        }
    }
}

enum DragGestureType {
    case None
    case LeftToRight
    case RightToLeft
    case TopToBottom
    case BottomToTop
}

struct ChatWindowView_Previews: PreviewProvider {
    static var previews: some View {
        ChatWindowView()
            .environmentObject(ChatViewModel(api: OpenAIAPI()))
    }
}
