//
//  Config.swift
//  LinkChat
//
//  Created by link on 2023/3/31.
//

import Foundation

struct Config {
    static let SECRET_KEY_NAME = "OpenAIKey"
    // 官方API地址，需要梯子才能访问
    // static let url  = "https://api.openai.com/v1/chat/completions"
    // 已使用代理，不需要梯子，手机移动网络也可以访问
    static let url  = "https://xuebusi.com/v1/chat/completions"
    static let method: String = "POST"
}
