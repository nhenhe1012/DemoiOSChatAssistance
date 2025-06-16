//
//  ChatViewViewModel.swift
//  Demo-iOS-Chat
//
//  Created by Tien Nguyen on 17/6/25.
//

import Foundation
import Combine

class ChatViewViewModel: BaseViewModel {
    @Published var messages: [ChatMessage] = [ChatMessage(text: "Xin chào!", isIncoming: true)]
    
    var messageUpdated = PassthroughSubject<Void, Never>()
    
    func setMessages(_ messages: [ChatMessage]) {
        self.messages.append(contentsOf: messages)
        self.messageUpdated.send()
    }
    
    func sendMessage(_ text: String) {
        let message = ChatMessage(text: text, isIncoming: false)
        setMessages([message])
        ChatService.shared.requestChat(with: text) { [unowned self] text in
            setMessages([ChatMessage(text: text, isIncoming: true)])
        }
    }
    
}
