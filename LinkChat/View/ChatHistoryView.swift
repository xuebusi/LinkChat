//
//  ChatHistoryView.swift
//  LinkChat
//
//  Created by link on 2023/4/21.
//

import SwiftUI

struct ChatHistoryView: View {
    @StateObject var hisVM = ChatHistoryViewModel()
    @State var showAlert: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(hisVM.hisQuestions, id: \.id) { question in
                    NavigationLink {
                        answerView(question: question)
                    } label: {
                        HStack {
                            Text(question.content)
                                .lineLimit(3)
                            Spacer()
                            Text(dateString(date: question.date))
                                .font(.system(.subheadline))
                                .foregroundColor(.gray)
                        }
                    }
                    
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("聊天记录")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                hisVM.loadHisQuestions()
            }
        }
        // 解决在iPad上视图被折叠问题
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

extension ChatHistoryView {
    func answerView(question: Message) -> some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("问题：\(question.content)")
                        .font(.system(.headline))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    Text(hisVM.getAnswer(questionId: question.id.uuidString))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.cyan.opacity(0.5))
                }
                .padding()
                .onTapGesture {
                    let copyText = """
                    问题：\(question.content)\n
                    \(hisVM.getAnswer(questionId: question.id.uuidString))\n
                    """
                    let pastebord = UIPasteboard.general
                    pastebord.string = copyText
                    showAlert.toggle()
                }
            }
        }
        .navigationTitle(question.content)
        .overlay(
            showAlert ? AnyView(
                SuccessAlertView(
                    isPresented: $showAlert,
                    message: "复制成功",
                    action: {
                        // 保存成功后的处理逻辑
                    }
                ).zIndex(1) // 将AlertView覆盖在主视图上
            ) : AnyView(EmptyView())
        )
    }
}

func dateString(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let dateString = formatter.string(from: date)
    return dateString
}

struct ChatHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ChatHistoryView()
    }
}
