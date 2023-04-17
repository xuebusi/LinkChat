//
//  ChatNavView.swift
//  LinkChat
//
//  Created by link on 2023/3/31.
//

import SwiftUI

struct ChatNavView: View {
    @StateObject var vm = ChatViewModel(api: OpenAIAPI())
    @State var selectionTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectionTab) {
            ChatWindowView()
                .tabItem {
                    Image(systemName: "ellipsis.bubble.fill")
                    Text("聊天")
                }
                .tag(0)
            
            ConfigFormView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("配置")
                }
                .tag(1)
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
