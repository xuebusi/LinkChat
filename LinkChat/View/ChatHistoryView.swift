//
//  ChatHistoryView.swift
//  LinkChat
//
//  Created by shiyanjun on 2023/4/21.
//

import SwiftUI

struct ChatHistoryView: View {
    @StateObject var hisVM = ChatHistoryViewModel()
    
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
                TextField("", text: Binding.constant(hisVM.getAnswer(questionId: question.id.uuidString)), axis: .vertical)
                    .padding()
                    .background(Color.cyan.opacity(0.5))
            }
        }
        .navigationTitle(question.content)
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
