//
//  Untitled 2.swift
//  Demo-iOS-Chat
//
//  Created by Tien Nguyen on 18/6/25.
//

import UIKit

class ChatCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    
    func configure(message: String) { }
}

class AssistantCell: ChatCell {
    
    override func configure(message: String) {
        messageLabel.textColor = .black.withAlphaComponent(0.9)
        let font = UIFont.systemFont(ofSize: 16)
        messageLabel.font = font
        
        if var attributed = try? AttributedString(markdown: message) {
            
            for run in attributed.runs {
                attributed[run.range].font = font
            }
            messageLabel.attributedText = NSAttributedString(attributed)
        } else {
            messageLabel.text = message
        }
    }
}
