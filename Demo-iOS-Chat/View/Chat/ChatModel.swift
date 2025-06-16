//
//  ChatModel.swift
//  Demo-iOS-Chat
//
//  Created by Tien Nguyen on 17/6/25.
//

import Foundation

struct ChatMessage: Codable {
    let text: String
    let isIncoming: Bool
}
