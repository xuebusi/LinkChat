//
//  ChatNavView.swift
//  LinkChat
//
//  Created by link on 2023/3/31.
//

import SwiftUI

struct ChatNavView: View {
    @StateObject var vm = ChatViewModel(api: OpenAIAPI())
    @State var selectionTab: Int = 1
    
    var body: some View {
        TabView(selection: $selectionTab) {
            ChatWindowView()
                .tabItem {
                    Image(systemName: "ellipsis.bubble.fill")
                    Text("聊天")
                }
                .tag(0)
            
            ChatHistoryView()
                .tabItem {
                    Image(systemName: "clock.badge.checkmark.fill")
                    Text("历史")
                }
                .tag(1)
            
            ConfigFormView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("配置")
                }
                .tag(2)
        }
        .accentColor(.cyan)
        .environmentObject(vm)
    }
}

struct ChatNavView_Previews: PreviewProvider {
    static var previews: some View {
        ChatNavView()
    }
}
