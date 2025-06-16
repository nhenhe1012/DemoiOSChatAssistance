//
//  ChatService.swift
//  Demo-iOS-Chat
//
//  Created by Tien Nguyen on 18/6/25.
//

import Foundation
import Combine

struct RouterAIChatMessage: Codable {
    let role: String // "system", "user", or "assistant"
    let content: String
}

struct RouterAIChatRequest: Codable {
    let model: String
    let messages: [RouterAIChatMessage]
}

class Choice: Codable {
    struct Message: Codable {
        let role: String
        let content: String
    }
    let message: Message
}

class RouterAIChatResponse: ResponseBase {
    required init(dict: [String : Any]) {
        super.init(dict: dict)
        
        if let choicesDict = dict["choices"],
           let choicesData = try? JSONDecoder().decode([Choice].self, from: JSONSerialization.data(withJSONObject: choicesDict)) {
            choices = choicesData
        }
    }
    var choices: [Choice] = []
}

class ChatService {
    static let shared = ChatService()
    
    var messages: [RouterAIChatMessage] = []
    
    func renewMessages() {
        messages = [.init(role: "system", content: systemPrompt)]
    }
    
    func requestChat(with text: String, completion: ((String) -> Void)?) {
        if messages.count == 0 {
            renewMessages()
        }
        var request = ChatPostRequest()
        messages.append(.init(role: "user", content: text))
        let data = RouterAIChatRequest(model: LLMModel.deepseek_R1_0528_qwen3.rawValue, messages: messages)
        request.body = try! JSONEncoder().encode(data)
        request.requestChat { response in
            var message: String = ""
            switch response {
            case .failure(let error):
                switch error {
                case .statusCode(let code, let mes):
                    message = "\(code): \(mes)"
                default: message = error.localizedDescription
                }
            case .success(let data):
                data.choices.forEach { choice in
                    if choice.message.role == "assistant" {
                        message = choice.message.content
                        self.messages.append(.init(role: "assistant", content: message))
                    }
                }
            }
            DispatchQueue.main.async {
                completion?(message)
            }
        }
    }
}
