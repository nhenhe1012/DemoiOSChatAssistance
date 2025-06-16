//
//  UserCell.swift
//  Demo-iOS-Chat
//
//  Created by Tien Nguyen on 18/6/25.
//

import UIKit

class UserCell: ChatCell {
    @IBOutlet weak var messageContentView: UIView!
    
    override func configure(message: String) {
        messageContentView.layer.cornerRadius = 8
        messageContentView.backgroundColor = .systemPink.withAlphaComponent(0.2)
        messageLabel.textColor = .black.withAlphaComponent(0.9)
        messageLabel.font = .systemFont(ofSize: 16)
        messageLabel.text = message
    }
}
