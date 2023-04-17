//
//  OpenAIAPI.swift
//  LinkChat
//
//  Created by link on 2023/4/2.
//

import Foundation

class OpenAIAPI: @unchecked Sendable {
    private let urlSession = URLSession.shared
    private var urlRequest: URLRequest {
        let url = URL(string: Config.url)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = Config.method
        urlRequest.timeoutInterval = 60
        headers.forEach {
            urlRequest.setValue($1, forHTTPHeaderField: $0)
        }
        return urlRequest
    }
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        return df
    }()
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    private var headers: [String: String] {
        [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(UserDefManager.getString(key: Config.SECRET_KEY_NAME))"
        ]
    }
    
    func sendMessageStream(text: String, context: String) async throws -> AsyncThrowingStream<String, Error> {
        let request = AIRequest(
            model: "gpt-3.5-turbo",
            temperature: 0.5,
            messages: [
                AIMessage(role: "system", content: context),
                AIMessage(role: "user", content: text),
            ],
            stream: true
        )
        
        var urlRequest = self.urlRequest
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        let urlSession = URLSession.shared
        
        let (result, response) = try await urlSession.bytes(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("无效的返回值!")
            throw "Invalid response"
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            var errorText = ""
            for try await line in result.lines {
                errorText += line
            }
            
            if let data = errorText.data(using: .utf8), let errorResponse = try? jsonDecoder.decode(ErrorRootResponse.self, from: data).error {
                errorText = "\n\(errorResponse.message)"
            }
            
            throw "Bad Response: \(httpResponse.statusCode), \(errorText)"
        }
        
        return AsyncThrowingStream<String, Error> { continuation in
            Task(priority: .userInitiated) { [weak self] in
                guard let self else { return }
                do {
                    var responseText = ""
                    for try await line in result.lines {
                        print(">>> line:\n")
                        print("\(line)")
                        if line.hasPrefix("data: "),
                           let data = line.dropFirst(6).data(using: .utf8),
                           let response = try? self.jsonDecoder.decode(AIStreamCompletionResponse.self, from: data),
                           let text = response.choices.first?.delta.content {
                            responseText += text
                            continuation.yield(text)
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
}


extension String: CustomNSError {
    
    public var errorUserInfo: [String : Any] {
        [
            NSLocalizedDescriptionKey: self
        ]
    }
}

