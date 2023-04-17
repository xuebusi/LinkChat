//
//  AIModel.swift
//  LinkChat
//
//  Created by link on 2023/4/2.
//

import Foundation

struct AIMessage: Codable {
    let role: String
    let content: String
}

struct AIRequest: Codable {
    let model: String
    let temperature: Double
    let messages: [AIMessage]
    let stream: Bool
}


struct ErrorRootResponse: Decodable {
    let error: ErrorResponse
}

struct ErrorResponse: Decodable {
    let message: String
    let type: String?
}

struct AIStreamCompletionResponse: Decodable {
    let choices: [AIStreamChoice]
}

struct AIStreamChoice: Decodable {
    let finishReason: String?
    let delta: AIStreamMessage
}

struct AIStreamMessage: Decodable {
    let role: String?
    let content: String?
}
