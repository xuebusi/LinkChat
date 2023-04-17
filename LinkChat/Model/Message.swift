//
//  Message.swift
//  LinkChat
//
//  Created by link on 2023/3/30.
//

import Foundation

struct Message: Identifiable, Hashable, Codable {
    var id = UUID()
    var role: MessageRole
    var content: String
    var status: MessageStatus
}

enum MessageRole: Codable {
    case me
    case robot
}

extension MessageRole {
    var isMe: Bool {
        switch self {
        case .me:
            return true
        case .robot:
            return false
        }
    }
    
    var name: String {
        switch self {
        case .me:
            return "我"
        case .robot:
            return "ChatGPT"
        }
    }
    
    var imageName: String {
        switch self {
        case .me:
            return "ME"
        case .robot:
            return "Robot"
        }
    }
}

